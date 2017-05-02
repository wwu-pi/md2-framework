package de.wwu.md2.framework.generator.android.lollipop.misc

import de.wwu.md2.framework.generator.android.lollipop.Settings

class GradleGen {
	// generates settings.gradle
	def static String generateProjectSettings()'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateProjectSettings()
		include ':app', '«Settings.MD2LIBRARY_DEBUG_PROJECT»'
	'''
	
	// generates build.gradle for the project
	def static String generateProjectBuild()'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateProjectBuild()
		buildscript {
			// Gradle thinks 2.2 > 2.14 ... workaround to allow build in Android Studio
			System.properties['com.android.build.gradle.overrideVersionCheck'] = 'true'
			
			repositories {
				jcenter()
			}
			dependencies {
				classpath 'com.android.tools.build:gradle:2.3.1'
			}
		}

		allprojects {
			repositories {
				jcenter()
			}
		}
	'''
	
	// generates build.gradle for the app
	def static String generateAppBuild(String appId, String version)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateAppBuild()
		apply plugin: 'com.android.application'
		
		android {
		    compileSdkVersion 25
		    buildToolsVersion "25"
		
		    defaultConfig {
		        applicationId "«appId»"
		        minSdkVersion 21
		        targetSdkVersion 25
		        versionCode 1
		        versionName "1.0"
		    }
		    buildTypes {
		        release {
		            minifyEnabled false
		            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
		        }
		        debug {
		            debuggable true
		            minifyEnabled false
		        }
		    }
			compileOptions {
		        sourceCompatibility JavaVersion.VERSION_1_7
		        targetCompatibility JavaVersion.VERSION_1_7
		    }
		}
		
		dependencies {
		    compile fileTree(include: ['*.jar'], dir: 'libs')
		    compile project('«Settings.MD2LIBRARY_DEBUG_PROJECT»')
		}
	'''
	
	// generates build.gradle for the app
	def static String generateMd2LibraryBuild()'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateMd2LibrarayBuild()
		configurations.create("default")
		artifacts.add("default", file('«Settings.MD2LIBRARY_DEBUG_NAME»'))
	'''
	
}