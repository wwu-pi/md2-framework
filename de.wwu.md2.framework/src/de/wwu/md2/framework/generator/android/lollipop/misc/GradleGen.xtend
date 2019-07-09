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
				google()
			}
			dependencies {
				classpath 'com.android.tools.build:gradle:3.4.1'
			}
		}

		allprojects {
			repositories {
				jcenter()
				google()
			}
		}
	'''
	
	// generates build.gradle for the app
	def static String generateAppBuild(String appId, String version)'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateAppBuild()
		apply plugin: 'com.android.application'
		
		android {
		    compileSdkVersion 26
		
		    defaultConfig {
		        applicationId "«appId»"
		        minSdkVersion 22
		        targetSdkVersion 28
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
		        sourceCompatibility JavaVersion.VERSION_1_8
		        targetCompatibility JavaVersion.VERSION_1_8
		    }
		}
		
		dependencies {
		    implementation fileTree(include: ['*.jar'], dir: 'libs')
		    implementation project('«Settings.MD2LIBRARY_DEBUG_PROJECT»')
			implementation group: 'com.j256.ormlite', name: 'ormlite-android', version: '4.45'
		    implementation 'com.google.code.gson:gson:2.8.2'
			implementation 'com.android.volley:volley:1.1.0'
			implementation 'com.android.support:recyclerview-v7:26.1.0'
			implementation 'com.android.support:support-v4:26.1.0'
			implementation 'com.android.support:exifinterface:26.1.0' // for image capture
		}
	'''
	
	// generates build.gradle for the app
	def static String generateMd2LibraryBuild()'''
		// generated in de.wwu.md2.framework.generator.android.lollipop.misc.Gradle.generateMd2LibrarayBuild()
		configurations.create("default")
		artifacts.add("default", file('«Settings.MD2LIBRARY_DEBUG_NAME»'))
	'''
	
}