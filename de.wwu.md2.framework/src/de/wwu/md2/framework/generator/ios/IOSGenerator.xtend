package de.wwu.md2.framework.generator.ios

import java.io.File;

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.generator.ios.util.FileSystemUtil

import de.wwu.md2.framework.generator.ios.model.iosEntity
import de.wwu.md2.framework.generator.ios.model.iosEnum
import de.wwu.md2.framework.generator.ios.controller.Controller
import org.eclipse.xtext.generator.IFileSystemAccessExtension2

//import static de.wwu.md2.framework.util.MD2Util.*

class IOSGenerator extends AbstractPlatformGenerator {
	
	var rootFolder = ""

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
			rootFolder = appRoot + mainPackage.replace(".", "/") + "/"
			printDebug("Generate App: " + rootFolder, true)

			// Copy static part in target folder
			val resourceFolderAbsolutePath = getClass().getResource("/resources/" + Settings.PLATTFORM_PREFIX + "/" + Settings.STATIC_CODE_PATH);
			val targetFolderAbsolutePath = (fsa as IFileSystemAccessExtension2).getURI(rootFolder).toFileString()
			
			FileSystemUtil.createParentDirs(new File(targetFolderAbsolutePath)) // ensure path exists
			
			printDebug("Copy library files with static code:")
			printDebug(FileSystemUtil.copyDirectory(
				new File(resourceFolderAbsolutePath.toURI()),
				new File(targetFolderAbsolutePath)).map[elem | elem.replace(targetFolderAbsolutePath, "").replace("\\","/") ].join("\n"))
//			
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
			 
			// Generate all model entities
			dataContainer.entities.filter[entity | !entity.name.startsWith("__")].forEach [entity | 
				val path = rootFolder + Settings.MODEL_PATH + "entity/" + entity.name + ".swift"
				printDebug("Generate entity: " + entity.name, path)
				fsa.generateFile(path, iosEntity.generateClass(entity))
			]
			
			// Generate all model enums
			dataContainer.enums.forEach [enum | 
				val path = rootFolder + Settings.MODEL_PATH + "enum/" + enum.name + ".swift"
				printDebug("Generate entity: " + enum.name, path)
				fsa.generateFile(path, iosEnum.generateClass(enum))
			]
			
			/***************************************************
			 * 
			 * View
			 * 
			 ***************************************************/
			 printDebug("Generate View mapper: " + rootFolder + Settings.VIEW_PATH, true)
			 
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
		printDebug(message + " (" + path.replace(rootFolder, "").replace("\\","/") + ")", false)
	}
}