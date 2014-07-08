package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess

import static de.wwu.md2.framework.generator.mapapps.AppJsonBuilder.*
import static de.wwu.md2.framework.generator.mapapps.ManifestJson.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import java.util.Collection

class MapAppsGenerator extends AbstractPlatformGenerator {
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Feasibility check
		/////////////////////////////////////////
		
		// Check whether a main block has been defined. Otherwise do not run the generator.
		if(dataContainer.main == null) {
			System::out.println("map.apps: No main block found. Quit gracefully.")
			return
		}
		
		
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
		
		// Generate common base elements
//		fsa.generateFile(basePackageName + "/app.json", generateAppJson(dataContainer, requiredBundles))
		fsa.generateFile(basePackageName + "/manifest.json", generateManifestJson(dataContainer, requiredBundles))
		
		
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
