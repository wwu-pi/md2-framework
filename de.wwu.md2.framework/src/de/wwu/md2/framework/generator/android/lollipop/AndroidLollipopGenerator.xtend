package de.wwu.md2.framework.generator.android.lollipop

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import static de.wwu.md2.framework.util.MD2Util.*
import de.wwu.md2.framework.generator.android.lollipop.misc.Gradle
import de.wwu.md2.framework.generator.android.lollipop.misc.Proguard
import de.wwu.md2.framework.generator.android.lollipop.misc.AndroidManifest
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil

class AndroidLollipopGenerator extends AbstractPlatformGenerator {

	override doGenerate(IExtendedFileSystemAccess fsa) {

		for (app : dataContainer.apps) {
	
			val rootFolder = rootFolder + "/md2_app_" + app.name
			
			// get main package for java code within the app
			val mainPackage = MD2GeneratorUtil.getBasePackageName(processedInput).replace("/", ".").toLowerCase

			// copy md2Library in the project
			fsa.generateFileFromInputStream(getSystemResource(Settings.MD2_RESOURCE_PATH + Settings.MD2LIBRARY_DEBUG_NAME), rootFolder + Settings.MD2LIBRARY_DEBUG_PATH + Settings.MD2LIBRARY_DEBUG_NAME)
			
			// android manifest
			val rootViews = dataContainer.rootViewContainers.filter[p1, p2| p1 == app].values.flatten
			fsa.generateFile(rootFolder + Settings.MAIN_PATH + Settings.ANDROID_MANIFEST_NAME, AndroidManifest.generateProjectAndroidManifest(app, rootViews ,mainPackage))
			
			// gradle build files
			fsa.generateFile(rootFolder + Settings.MD2LIBRARY_DEBUG_PATH + Settings.GRADLE_BUILD, Gradle.generateMd2LibrarayBuild)
			fsa.generateFile(rootFolder + "/" + Settings.GRADLE_BUILD, Gradle.generateProjectBuild)
			fsa.generateFile(rootFolder + "/" + Settings.GRADLE_SETTINGS, Gradle.generateProjectSettings)
			fsa.generateFile(rootFolder + Settings.APP_PATH + Settings.GRADLE_BUILD, Gradle.generateAppBuild(mainPackage, dataContainer.main.appVersion))
			
			// proguard rules
			fsa.generateFile(rootFolder + Settings.APP_PATH + Settings.PROGUARD_RULES_NAME, Proguard.generateProjectProguardRules)	
		}
	}

	override getPlatformPrefix() {
		Settings.PLATTFORM_PREFIX
	}

}