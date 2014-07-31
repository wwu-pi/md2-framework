package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess

import static de.wwu.md2.framework.generator.mapapps.ContentProviderClass.*
import static de.wwu.md2.framework.generator.mapapps.ControllerClass.*
import static de.wwu.md2.framework.generator.mapapps.CustomActionClass.*
import static de.wwu.md2.framework.generator.mapapps.CustomActionInterfaceClass.*
import static de.wwu.md2.framework.generator.mapapps.EntityClass.*
import static de.wwu.md2.framework.generator.mapapps.EntityInterfaceClass.*
import static de.wwu.md2.framework.generator.mapapps.ManifestJson.*
import static de.wwu.md2.framework.generator.mapapps.ModuleClass.*

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class MapAppsGenerator extends AbstractPlatformGenerator {
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Generation work flow
		/////////////////////////////////////////
		
		// Copy resources
		fsa.copyFileFromProject("resources/images", rootFolder + "/resources")
		
		// Generate common base elements
		fsa.generateFile(rootFolder + "/manifest.json", generateManifestJson(dataContainer, processedInput).tabsToSpaces(4))
		
		fsa.generateFile(rootFolder + "/module.js", generateModule(dataContainer).tabsToSpaces(4))
		
		fsa.generateFile(rootFolder + "/Controller.js", generateController(dataContainer).tabsToSpaces(4))
		
		fsa.generateFile(rootFolder + "/CustomActions.js", generateCustomActionInterface(dataContainer).tabsToSpaces(4))
		
		fsa.generateFile(rootFolder + "/Entities.js", generateEntityInterface(dataContainer).tabsToSpaces(4))
		
		for (customAction : dataContainer.customActions) {
			fsa.generateFile(rootFolder + "/actions/" + customAction.name.toFirstUpper + ".js", generateCustomAction(customAction).tabsToSpaces(4))
		}
		
		for (entity : dataContainer.entities) {
			fsa.generateFile(rootFolder + "/entities/" + entity.name.toFirstUpper + ".js", generateEntity(entity).tabsToSpaces(4))
		}
		
		for (contentProvider : dataContainer.contentProviders) {
			fsa.generateFile(rootFolder + "/contentproviders/" + contentProvider.name.toFirstUpper + ".js", generateContentProvider(contentProvider, processedInput).tabsToSpaces(4))
		}
		
		
		/////////////////////////////////////////
		// Build zip file for bundle
		/////////////////////////////////////////
		
		val zipFileName = '''md2_app_«processedInput.getBasePackageName.split("\\.").reduce[ s1, s2 | s1 + "_" + s2]».zip'''
		fsa.zipDirectory(rootFolder, rootFolder + "/../" + zipFileName);
		
	}
	
	override getPlatformPrefix() {
		"mapapps"
	}
	
	override getDefaultSubfolder() {
		"md2_app_" + processedInput.getBasePackageName.split("\\.").reduce[ s1, s2 | s1 + "_" + s2]
	}
	
}
