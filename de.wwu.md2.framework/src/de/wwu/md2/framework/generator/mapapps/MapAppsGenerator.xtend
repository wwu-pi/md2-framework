package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import java.util.Collection

import static de.wwu.md2.framework.generator.mapapps.ContentProviderClass.*
import static de.wwu.md2.framework.generator.mapapps.ControllerClass.*
import static de.wwu.md2.framework.generator.mapapps.CustomActionClass.*
import static de.wwu.md2.framework.generator.mapapps.EntityClass.*
import static de.wwu.md2.framework.generator.mapapps.ManifestJson.*
import static de.wwu.md2.framework.generator.mapapps.ModuleClass.*

class MapAppsGenerator extends AbstractPlatformGenerator {
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Calculate bundle dependencies
		/////////////////////////////////////////
		
		val Collection<String> requiredBundles = newArrayList
		
		requiredBundles.add("system")
		requiredBundles.add("splashscreen")
		requiredBundles.add("templatelayout")
		requiredBundles.add("themes")
		requiredBundles.add("templates")
		requiredBundles.add("windowmanager")
		
		
		/////////////////////////////////////////
		// Generation work flow
		/////////////////////////////////////////
		
		// Clean current project folder
		fsa.deleteDirectory(basePackageName)
		
		// Copy resources
		fsa.copyFileFromProject("resources/images", basePackageName + "/resources")
		
		// Generate common base elements
//		fsa.generateFile(basePackageName + "/app.json", generateAppJson(dataContainer, requiredBundles))
		fsa.generateFile(basePackageName + "/manifest.json", generateManifestJson(dataContainer, processedInput))
		
		fsa.generateFile(basePackageName + "/module.js", generateModule(dataContainer))
		
		fsa.generateFile(basePackageName + "/Controller.js", generateController)
		
		for (customAction : dataContainer.customActions) {
			fsa.generateFile(basePackageName + "/actions/" + customAction.name.toFirstUpper + ".js", generateCustomAction(customAction, dataContainer))
		}
		
		for (entity : dataContainer.entities) {
			fsa.generateFile(basePackageName + "/entities/" + entity.name.toFirstUpper + ".js", generateEntity(entity))
		}
		
		for (contentProvider : dataContainer.contentProviders) {
			fsa.generateFile(basePackageName + "/contentproviders/" + contentProvider.name.toFirstUpper + ".js", generateContentProvider(contentProvider, processedInput))
		}
		
		
		
		/////////////////////////////////////////
		// Generate models
		/////////////////////////////////////////
		
		
		
		/////////////////////////////////////////
		// Generate views
		/////////////////////////////////////////
		
		
		
		/////////////////////////////////////////
		// Generate controllers
		/////////////////////////////////////////
		
		
		
		/////////////////////////////////////////
		// Build app (zip file)
		/////////////////////////////////////////
		
//		fsa.deleteFile(createAppName(dataContainer) + ".zip")
//		fsa.zipDirectory(basePackageName, createAppName(dataContainer) + ".zip");
		
	}
	
	override getPlatformPrefix() {
		"mapapps"
	}
	
}
