package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.ios.controller.Controller
import de.wwu.md2.framework.generator.ios.model.IOSContentProvider
import de.wwu.md2.framework.generator.ios.model.IOSEntity
import de.wwu.md2.framework.generator.ios.model.IOSEnum
import de.wwu.md2.framework.generator.ios.model.WidgetMapping
import de.wwu.md2.framework.generator.ios.util.FileSystemUtil
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.SimpleType
import java.io.File
import org.eclipse.xtext.generator.IFileSystemAccessExtension2

import static de.wwu.md2.framework.generator.ios.Settings.*
import de.wwu.md2.framework.generator.ios.model.DataModel

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
			val appRoot = rootFolder + "/" + app.name + "." + Settings.PLATFORM_PREFIX + "/"
			val mainPackage = MD2GeneratorUtil.getBasePackageName(processedInput).replace("^/", ".").toLowerCase
			rootFolder = appRoot + mainPackage.replace(".", "/") + "/"
			Settings.ROOT_FOLDER = rootFolder
			GeneratorUtil.printDebug("Generate App: " + rootFolder, true)

			// Copy static part in target folder
			val resourceFolderAbsolutePath = getClass().getResource("/resources/" 
				+ Settings.PLATFORM_PREFIX + "/" + Settings.STATIC_CODE_PATH);
			val targetFolderAbsolutePath = (fsa as IFileSystemAccessExtension2).getURI(rootFolder).toFileString()
			
			FileSystemUtil.createParentDirs(new File(targetFolderAbsolutePath)) // ensure path exists
			
			GeneratorUtil.printDebug("Copy library files with static code:")
			GeneratorUtil.printDebug(FileSystemUtil.copyDirectory(
				new File(resourceFolderAbsolutePath.toURI()),
				new File(targetFolderAbsolutePath)).map[elem | 
					elem.replace(targetFolderAbsolutePath, "").replace("\\","/")
				].join("\n"))
//			
//			// all root views for current app
//			val rootViews = app.workflowElements.map [ wer |
//				dataContainer.rootViewContainers.get(wer.workflowElementReference)
//			].flatten
//			
//			// all content elements
//			val viewGUIElements = rootViews.map[rv | rv.eAllContents.filter(ViewGUIElement).toSet].flatten
//
//			
			/***************************************************
			 * 
			 * Misc 
			 * Project file, ...
			 * 
			 ***************************************************/
			// TODO

			/***************************************************
			 * 
			 * Model
			 * 
			 ***************************************************/
			GeneratorUtil.printDebug("Generate Model: " + rootFolder + Settings.MODEL_PATH, true)
			 
			// Generate all model entities
			val entities = dataContainer.entities.filter[entity | !entity.name.startsWith("__")]
			entities.forEach [entity | 
				val path = rootFolder + Settings.MODEL_PATH + "entity/" 
					+ Settings.PREFIX_ENTITY + entity.name + ".swift"
				GeneratorUtil.printDebug("Generate entity: " + entity.name, path)
				fsa.generateFile(path, IOSEntity.generateClass(entity))
			]
			
			// Generate all model enums
			dataContainer.enums.forEach [enum | 
				val path = rootFolder + Settings.MODEL_PATH + "enum/" 
					+ Settings.PREFIX_ENUM + enum.name + ".swift"
				GeneratorUtil.printDebug("Generate entity: " + enum.name, path)
				fsa.generateFile(path, IOSEnum.generateClass(enum))
			]
			
			// Generate WidgetMapping as (platform) enum
			val pathWidgetMapping = rootFolder + Settings.MODEL_PATH + "enum/WidgetMapping.swift"
			GeneratorUtil.printDebug("Generate View mapping: ", rootFolder + Settings.VIEW_PATH)
			fsa.generateFile(pathWidgetMapping, WidgetMapping.generateClass(dataContainer.view))
			
			// Generate content providers
			dataContainer.contentProviders.filter[cp | !cp.name.startsWith("__")].forEach [ cp |
				val path = rootFolder + Settings.MODEL_PATH + "contentProvider/"  
					+ Settings.PREFIX_CONTENT_PROVIDER + cp.name + ".swift"
				
				// TODO ContentProvider for simple data type -> what is this for?
				if (cp.type instanceof SimpleType) {
					GeneratorUtil.printError("SimpleType unsupported in ContentProvider!")
				} else {
					GeneratorUtil.printDebug("Generate content provider: " + cp.name, path)
					fsa.generateFile(path, IOSContentProvider.generateClass(cp))
				}
			]
			
			// Generate data model for local storage
			val pathDataModel = rootFolder + Settings.MODEL_PATH 
				+ "datastore/LocalData.xcdatamodeld/LocalData.xcdatamodel/contents"
			fsa.generateFile(pathDataModel, DataModel.generateClass(entities))
			
			/***************************************************
			 * 
			 * View
			 * 
			 ***************************************************/
			// TODO
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
			 GeneratorUtil.printDebug("Generate Main Controller: " + rootFolder + Settings.CONTROLLER_PATH, true)
			 fsa.generateFile(rootFolder + Settings.CONTROLLER_PATH + "Controller.swift", Controller.generateStartupController(dataContainer))
			 
			/***************************************************
			 * 
			 * Workflow
			 * 
			 ***************************************************/
			// TODO
		}

		println("\nIOS GENERATION COMPLETED\n")
	}

	override getPlatformPrefix() {
		Settings.PLATFORM_PREFIX
	}
}