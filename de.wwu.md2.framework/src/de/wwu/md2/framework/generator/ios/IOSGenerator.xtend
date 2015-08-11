package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil

import de.wwu.md2.framework.generator.ios.model.Model
import de.wwu.md2.framework.generator.ios.controller.Controller

class IOSGenerator extends AbstractPlatformGenerator {

	override doGenerate(IExtendedFileSystemAccess fsa) {
		System.out.println("START GENERATION")
		
		/***************************************************
		 * 
		 * Generate apps individually
		 * 
		 ***************************************************/
		for (app : dataContainer.apps) {
			// Folders
			val appRoot = rootFolder + "/md2_app_" + app.name + "/"
			val mainPackage = MD2GeneratorUtil.getBasePackageName(processedInput).replace("^/", ".").toLowerCase
			val rootFolder = appRoot + mainPackage.replace(".", "/") + "/"
			printDebug("Generate App: " + rootFolder, true)


//			// all root views for current app
//			val rootViews = app.workflowElements.map [ wer |
//				dataContainer.rootViewContainers.get(wer.workflowElementReference)
//			].flatten
//			
//			// all content elements
//			val viewGUIElements = rootViews.map[rv | rv.eAllContents.filter(ViewGUIElement).toSet].flatten
//
//			/***************************************************
//			 * 
//			 * MD2 Library for android
//			 * 
//			 ***************************************************/
//			// copy md2Library in the project
//			fsa.generateFileFromInputStream(
//				getSystemResource(Settings.MD2_RESOURCE_PATH + Settings.MD2LIBRARY_DEBUG_NAME),
//				rootFolder + Settings.MD2LIBRARY_DEBUG_PATH + Settings.MD2LIBRARY_DEBUG_NAME)
//
//			// copy mipmap resources
//			// TODO: copy whole folder instead of each file separately
//			fsa.generateFileFromInputStream(
//				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-hdpi/ic_launcher.png"),
//				rootFolder + Settings.MIPMAP_PATH + "mipmap-hdpi/ic_launcher.png")
//			fsa.generateFileFromInputStream(
//				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-mdpi/ic_launcher.png"),
//				rootFolder + Settings.MIPMAP_PATH + "mipmap-mdpi/ic_launcher.png")
//			fsa.generateFileFromInputStream(
//				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-xhdpi/ic_launcher.png"),
//				rootFolder + Settings.MIPMAP_PATH + "mipmap-xhdpi/ic_launcher.png")
//			fsa.generateFileFromInputStream(
//				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-xxhdpi/ic_launcher.png"),
//				rootFolder + Settings.MIPMAP_PATH + "mipmap-xxhdpi/ic_launcher.png")
//
//			/***************************************************
//			 * 
//			 * Misc 
//			 * Manifest, Gradle and Proguard
//			 * 
//			 ***************************************************/
//			// android manifest						
//			fsa.generateFile(rootFolder + Settings.MAIN_PATH + Settings.ANDROID_MANIFEST_NAME,
//				AndroidManifest.generateProjectAndroidManifest(app, rootViews, mainPackage))
//
//			// gradle build files
			
			/***************************************************
			 * 
			 * Model
			 * 
			 ***************************************************/
			printDebug("Generate Model: " + rootFolder + Settings.MODEL_PATH, true)
			 
			// All model entities
			dataContainer.entities.filter[entity | !entity.name.startsWith("__")].forEach [entity | 
				val path = rootFolder + Settings.MODEL_PATH + entity.name + ".swift"
				printDebug("Generate entity: " + entity.name, path)
				fsa.generateFile(path, Model.generateEntity(entity))
			]
			
			
			/***************************************************
			 * 
			 * View
			 * 
			 ***************************************************/
			/*printDebug("Generate Views: " + rootFolder + Settings.MODEL_PATH, true)
			 
			// All model entities
			dataContainer.view.viewElements.forEach [view | 
				val path = rootFolder + Settings.CONTROLLER_PATH + entity.name + ".swift"
				printDebug("Generate entity: " + entity.name, path)
				fsa.generateFile(path, Model.generateEntity(entity))
			]*/

			/***************************************************
			 * 
			 * Controller
			 * 
			 ***************************************************/
			 printDebug("Generate Main Controller: " + rootFolder + Settings.CONTROLLER_PATH, true)
			 fsa.generateFile(rootFolder + Settings.CONTROLLER_PATH + "Controller.swift", Controller.generateStartupController(dataContainer))
			 
			/***************************************************
			 * 
			 * Workflow
			 * 
			 ***************************************************/
		}

		println("\nGENERATION COMPLETED")
	}

	override getPlatformPrefix() {
		Settings.PLATTFORM_PREFIX
	}

	// Output sensible information during generation process
	def printDebug(String message, Boolean withSeparator) {
		if(Settings.PRINT_DEBUG_INFO) {
			if (withSeparator)  println("\n/**************************************************")
			
			println(message)
			
			if (withSeparator) println("**************************************************/")
		}
	}
	
	def printDebug(String message) {
		printDebug(message, false)
	}
	
	def printDebug(String message, String path) {
		printDebug(message + " (" + path + ")", false)
	}
}