package de.wwu.md2.framework.generator.android.lollipop

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import org.apache.commons.io.FileUtils
import java.io.IOException
import java.io.File
import java.nio.file.Path

class AndroidLollipopGenerator extends AbstractPlatformGenerator {

	override doGenerate(IExtendedFileSystemAccess fsa) {

		for (app : dataContainer.apps) {

			val rootFolder = rootFolder + "/md2_app_" + app.name
			this.copyAndroidLibrary()
			fsa.generateFile(rootFolder + "/content.txt", generateSth())
		}
	}

	// Copies the Library for Android app in the apps location
	def copyAndroidLibrary() {
	    val source = new File("C:\\Users\\Fabian\\Documents\\A")
		val dest = new File("C:\\Users\\Fabian\\Documents\\B")
		try {
			FileUtils.copyDirectory(source, dest)
		} catch (IOException e) {
			e.printStackTrace()
		}
	}

	def generateSth() {
		'''some content'''
	}

	override getPlatformPrefix() {
		"androidLollipop"
	}

}