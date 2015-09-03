package de.wwu.md2.framework.generator.android.lollipop

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.lollipop.controller.Actions
import de.wwu.md2.framework.generator.android.lollipop.controller.Activity
import de.wwu.md2.framework.generator.android.lollipop.controller.Application
import de.wwu.md2.framework.generator.android.lollipop.controller.Md2Controller
import de.wwu.md2.framework.generator.android.lollipop.misc.AndroidManifest
import de.wwu.md2.framework.generator.android.lollipop.misc.Gradle
import de.wwu.md2.framework.generator.android.lollipop.misc.Proguard
import de.wwu.md2.framework.generator.android.lollipop.model.Md2ContentProvider
import de.wwu.md2.framework.generator.android.lollipop.model.Md2Entity
import de.wwu.md2.framework.generator.android.lollipop.model.SQLite
import de.wwu.md2.framework.generator.android.lollipop.view.Layout
import de.wwu.md2.framework.generator.android.lollipop.view.Values
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.ViewGUIElement
import org.apache.log4j.Logger

import static de.wwu.md2.framework.util.MD2Util.*

class AndroidLollipopGenerator extends AbstractPlatformGenerator {

	override doGenerate(IExtendedFileSystemAccess fsa) {

		val Logger log = Logger.getLogger(this.class)

		log.info("Android Lollipop Generator started")

		for (app : dataContainer.apps) {

			log.info("Android Lollipop Generator: generate app: \"" + app.appName + "\"")

			/***************************************************
			 * 
			 * Data for the sub-generators
			 * 
			 ***************************************************/
			// root folder
			val rootFolder = rootFolder + "/md2_app_" + app.name

			// main package and path for java code within Android project
			val mainPackage = "md2." +
				MD2GeneratorUtil.getBasePackageName(processedInput).replace("^/", ".").toLowerCase
			val mainPath = mainPackage.replace(".", "/") + "/"

			// all workflow elements for app
			val workflowElements = dataContainer.workflowElementsForApp(app)

			// all root views for current app
			val rootViews = app.workflowElements.map [ wer |
				dataContainer.rootViewContainers.get(wer.workflowElementReference)
			].flatten.toSet

			// all GUI elements for app
			val viewGUIElements = rootViews + rootViews.map[rv|rv.eAllContents.filter(ViewGUIElement).toSet].flatten
			
			// startable WorkflowElements
			val startableWorkflowElements = app.workflowElements.filter[we|we.startable]

			/***************************************************
			 * 
			 * MD2 Library for Android and Resources
			 * 
			 ***************************************************/
			// copy md2Library for Android to the project
			fsa.generateFileFromInputStream(
				getSystemResource(Settings.MD2_RESOURCE_PATH + Settings.MD2LIBRARY_DEBUG_NAME),
				rootFolder + Settings.MD2LIBRARY_DEBUG_PATH + Settings.MD2LIBRARY_DEBUG_NAME)

			// copy mipmap resources
			// TODO: copy whole folder instead of each file separately
			fsa.generateFileFromInputStream(
				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-hdpi/ic_launcher.png"),
				rootFolder + Settings.MIPMAP_PATH + "mipmap-hdpi/ic_launcher.png")
			fsa.generateFileFromInputStream(
				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-mdpi/ic_launcher.png"),
				rootFolder + Settings.MIPMAP_PATH + "mipmap-mdpi/ic_launcher.png")
			fsa.generateFileFromInputStream(
				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-xhdpi/ic_launcher.png"),
				rootFolder + Settings.MIPMAP_PATH + "mipmap-xhdpi/ic_launcher.png")
			fsa.generateFileFromInputStream(
				getSystemResource(Settings.MD2_RESOURCE_MIPMAP_PATH + "mipmap-xxhdpi/ic_launcher.png"),
				rootFolder + Settings.MIPMAP_PATH + "mipmap-xxhdpi/ic_launcher.png")

			/***************************************************
			 * 
			 * Misc 
			 * Manifest, Gradle and Proguard
			 * 
			 ***************************************************/
			// android manifest					
			fsa.generateFile(rootFolder + Settings.MAIN_PATH + Settings.ANDROID_MANIFEST_NAME,
				AndroidManifest.generateProjectAndroidManifest(app, rootViews, mainPackage))

			// gradle build files
			fsa.generateFile(rootFolder + Settings.MD2LIBRARY_DEBUG_PATH + Settings.GRADLE_BUILD_NAME,
				Gradle.generateMd2LibrarayBuild)
			fsa.generateFile(rootFolder + "/" + Settings.GRADLE_BUILD_NAME, Gradle.generateProjectBuild)
			fsa.generateFile(rootFolder + "/" + Settings.GRADLE_SETTINGS_NAME, Gradle.generateProjectSettings)
			fsa.generateFile(rootFolder + Settings.APP_PATH + Settings.GRADLE_BUILD_NAME,
				Gradle.generateAppBuild(mainPackage, dataContainer.main.appVersion))

			// proguard rules
			fsa.generateFile(rootFolder + Settings.APP_PATH + Settings.PROGUARD_RULES_NAME,
				Proguard.generateProjectProguardRules)

			/***************************************************
			 * 
			 * Model
			 * 
			 ***************************************************/
			// Entities
			Md2Entity.generateEntities(fsa, rootFolder, mainPath, mainPackage, dataContainer.entities)

			// Content Provider
			Md2ContentProvider.generateContentProviders(fsa, rootFolder, mainPath, mainPackage,
				dataContainer.contentProviders)

			// SQLite classes (DataContract and SQLiteHelper)
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "/md2/model/sqlite/Md2DataContract.java",
				SQLite.generateDataContract(mainPackage, dataContainer.getEntities))
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "/md2/model/sqlite/Md2SQLiteHelperImpl.java",
				SQLite.generateSQLiteHelper(mainPackage, app, dataContainer.getMain, dataContainer.getEntities))

			/***************************************************
			 * 
			 * View
			 * 
			 ***************************************************/
			// Element Ids
			fsa.generateFile(rootFolder + Settings.VALUES_PATH + Settings.IDS_XML_NAME,
				Values.generateIdsXml(viewGUIElements, startableWorkflowElements))

			// String Values
			fsa.generateFile(rootFolder + Settings.VALUES_PATH + Settings.STRINGS_XML_NAME,
				Values.generateStringsXml(app, rootViews, viewGUIElements))

			// Views String Values
			fsa.generateFile(rootFolder + Settings.VALUES_PATH + Settings.VIEWS_XML_NAME,
				Values.generateViewsXml(rootViews, mainPackage))

			// Styles
			fsa.generateFile(rootFolder + Settings.VALUES_PATH + Settings.STYLES_XML_NAME, Values.generateStylesXml)

			// Dimensions
			fsa.generateFile(rootFolder + Settings.VALUES_PATH + Settings.DIMENS_XML_NAME, Values.generateDimensXml)

			// Layouts
			Layout.generateLayouts(fsa, rootFolder, mainPath, mainPackage, rootViews, startableWorkflowElements)

			/***************************************************
			 * 
			 * Controller
			 * 
			 ***************************************************/
			// Application class
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + app.name.toFirstUpper + ".java",
				Application.generateAppClass(mainPackage, app))

			// Activities
			Activity.generateActivities(fsa, rootFolder, mainPath, mainPackage, rootViews, startableWorkflowElements)

			// Controller
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "/md2/controller/Controller" + ".java",
				Md2Controller.generateController(mainPackage, app, dataContainer.entities,
					dataContainer.contentProviders))

			// Actions
			Actions.generateActions(fsa, rootFolder, mainPath, mainPackage, app, workflowElements)

			/***************************************************
			 * 
			 * Workflow
			 * TODO: Workflows are not supported for now. Therefore, this section is empty.
			 * 
			 ***************************************************/
			log.info("Android Lollipop Generator: generate app: \"" + app.appName + "\" finished")
		}
		log.info("Android Lollipop Generator finished")
	}

	override getPlatformPrefix() {
		Settings.PLATTFORM_PREFIX
	}

}