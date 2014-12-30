package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CustomAction

import static de.wwu.md2.framework.generator.mapapps.AppClass.*
import static de.wwu.md2.framework.generator.mapapps.ContentProviderClass.*
import static de.wwu.md2.framework.generator.mapapps.ControllerClass.*
import static de.wwu.md2.framework.generator.mapapps.CustomActionClass.*
import static de.wwu.md2.framework.generator.mapapps.CustomActionsInterfaceClass.*
import static de.wwu.md2.framework.generator.mapapps.EntityClass.*
import static de.wwu.md2.framework.generator.mapapps.EnumClass.*
import static de.wwu.md2.framework.generator.mapapps.EventHandlerClass.*
import static de.wwu.md2.framework.generator.mapapps.ManifestJson.*
import static de.wwu.md2.framework.generator.mapapps.ModelsInterfaceClass.*
import static de.wwu.md2.framework.generator.mapapps.ModuleClass.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.StringExtensions.*
import static extension de.wwu.md2.framework.generator.mapapps.util.MD2MapappsUtil.*
import static de.wwu.md2.framework.util.MD2Util.*

class MapAppsGenerator extends AbstractPlatformGenerator {
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Generation of the application and all its bundles
		/////////////////////////////////////////
		
		var bundlesRootFolder = rootFolder + "/bundles"
		
		// Copy static map.apps files (map layers)
        fsa.generateFileFromInputStream(getSystemResource("/mapapps/services-init.json"), rootFolder + "/services-init.json")
        fsa.generateFileFromInputStream(getSystemResource("/mapapps/services.json"), rootFolder + "/services.json")
		
		fsa.generateFile(rootFolder + "/app.json", generateAppJson(dataContainer).tabsToSpaces(4))
		
		fsa.generateFile(bundlesRootFolder + "/bundles.json", generateBundleJson(dataContainer).tabsToSpaces(4))
		
		// Generate a separate bundle for each workflow element specified in the application model
		for(WorkflowElement workflowElement : dataContainer.controllers.head.controllerElements.filter(WorkflowElement)) {
			var bundleFolder = bundlesRootFolder + "/" + workflowElement.bundleName 
			
			generateWorkflowElementBundle(fsa, bundleFolder, workflowElement)
		}
		
		generateModelsBundle(fsa, bundlesRootFolder + "/md2_models")
		generateContentProvidersBundle(fsa, bundlesRootFolder + "/md2_contentproviders")
		generateWorkflowBundle(fsa, bundlesRootFolder + "/md2_workflow")
		
		/////////////////////////////////////////
		// Build zip file for application
		/////////////////////////////////////////
		
		val zipFileName = '''md2_app_«processedInput.getBasePackageName.split("\\.").reduce[ s1, s2 | s1 + "_" + s2]».zip'''
		fsa.zipDirectory(rootFolder, rootFolder + "/../" + zipFileName);
		
	}
	
	/* Generate a bundle for each workflow element specified in the application model. 
	 * Each bundle contains its own manifest.json, module.js, Controller.js and CustomActions.js.
	 * All custom actions are inserted into a separate folder called "actions".
	 */
	
	def generateWorkflowElementBundle(IExtendedFileSystemAccess fsa, String bundleFolder, WorkflowElement workflowElement) {
		fsa.generateFile(bundleFolder + "/module.js", generateModuleForWorkflowElement().tabsToSpaces(4))
		
		fsa.generateFile(bundleFolder + "/manifest.json", generateManifestJsonForWorkflowElement(workflowElement, dataContainer, processedInput).tabsToSpaces(4))
		
		fsa.generateFile(bundleFolder + "/Controller.js", generateController(dataContainer).tabsToSpaces(4))
		
		fsa.generateFile(bundleFolder + "/CustomActions.js", generateCustomActionsInterface(dataContainer, workflowElement).tabsToSpaces(4))
		
		//Put all custom actions in an additional folder
		for (customAction : workflowElement.actions.filter(CustomAction)) {
			fsa.generateFile(bundleFolder + "/actions/" + customAction.name.toFirstUpper + ".js", generateCustomAction(customAction).tabsToSpaces(4))
		}
		
	}
	
	/* Generate a bundle for the model specified in the application model. 
	 * This bundle contains its own manifest.json, module.js and Models.js.
	 * All entities and enums specified in the application model are inserted into a separate folder called "models".
	 */	
	
	def generateModelsBundle(IExtendedFileSystemAccess fsa, String modelBundleFolder){
		fsa.generateFile(modelBundleFolder + "/module.js", generateModuleForModels().tabsToSpaces(4))
		
		fsa.generateFile(modelBundleFolder + "/manifest.json", generateManifestJsonForModels(dataContainer, processedInput).tabsToSpaces(4))
		
		fsa.generateFile(modelBundleFolder + "/Models.js", generateModelsInterface(dataContainer).tabsToSpaces(4))
		
		//put all entities in the in an additional folder called models
		for (entity : dataContainer.entities) {
			fsa.generateFile(modelBundleFolder + "/models/" + entity.name.toFirstUpper + ".js", generateEntity(entity).tabsToSpaces(4))
		}
		
		//put all enums in the in an additional folder called models
		for (^enum : dataContainer.enums) {
			fsa.generateFile(modelBundleFolder + "/models/" + enum.name.toFirstUpper + ".js", generateEnum(enum).tabsToSpaces(4))
		}	
	}
	
	/* Generate a bundle for the workflow event handler. This event handler is responsible for starting and finishing 
	 * workflow elements based on events fired by workflow elements.
	 * The bundle contains its own manifest.json, module.js and a class called WorkflowEventHandler.js.
	 */	
	def generateWorkflowBundle(IExtendedFileSystemAccess fsa, String workflowBundleFolder){
		fsa.generateFile(workflowBundleFolder + "/module.js", generateModuleForWorkflowHandler().tabsToSpaces(4))
		
		fsa.generateFile(workflowBundleFolder + "/manifest.json", generateManifestJsonForWorkflowHandler(dataContainer, processedInput).tabsToSpaces(4))
		
		fsa.generateFile(workflowBundleFolder + "/WorkflowEventHandler.js", generateWorkflowEventHandler(dataContainer, processedInput).tabsToSpaces(4))
	}
	
	/* Generate a bundle for the content providers specified in the application model.  
	 * This bundle contains its own manifest.json, module.js and Models.js. and a folder in which all content providers are inserted.
	 */	
	def generateContentProvidersBundle (IExtendedFileSystemAccess fsa, String contentProviderBundleFolder){
		fsa.generateFile(contentProviderBundleFolder + "/module.js", generateModuleForContentProviders(dataContainer).tabsToSpaces(4))
		fsa.generateFile(contentProviderBundleFolder + "/manifest.json", generateManifestJsonForContentProviders(dataContainer, processedInput).tabsToSpaces(4))
		
		//put all content providers in the in an additional folder called "contentproviders"
		for (contentProvider : dataContainer.contentProviders) {
			fsa.generateFile(contentProviderBundleFolder + "/contentproviders/" + contentProvider.name.toFirstUpper + ".js", generateContentProvider(contentProvider, processedInput).tabsToSpaces(4))
		}
	}
	
	//TODO: Find correct location
//		fsa.copyFileFromProject("resources/images", bundleFolder + "/resources")
	
	override getPlatformPrefix() {
		"mapapps"
	}
	
	override getDefaultSubfolder() {
		"md2_app_" + processedInput.getBasePackageName.split("\\.").reduce[ s1, s2 | s1 + "_" + s2]
	}
	
}
