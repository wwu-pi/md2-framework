package de.wwu.md2.framework.generator.android.common

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.ContainerElement
import java.util.List

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class Manifest {
	
	/**
	 * Creates the manifest for the app
	 * @param activities List of all root views that have been created, the first entry has to be the entry point to the app
	 */
	def static manifest(String packageName, int minAppVersion, DataContainer dataContainer, List<ContainerElement> activities) '''
		<?xml version="1.0" encoding="utf-8"?>
		<manifest xmlns:android="http://schemas.android.com/apk/res/android"
			package="«packageName»"
			android:versionCode="1"
			android:versionName="0.1" >
		
			<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
			«IF !dataContainer.contentProviders.filter([!it.local]).empty»
				<uses-permission android:name="android.permission.INTERNET" />
			«ENDIF»
			<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
		    
			<uses-sdk android:minSdkVersion="«minAppVersion»" />
			
			<application
				android:icon="@drawable/ic_launcher"
				android:label="«createAppName(dataContainer)»"
				android:name="«packageName».«createAppClassName(dataContainer)»" >
				
					«FOR activity : activities» 
						«activity(activity.name.toFirstUpper+"Activity", activity == activities.head)»
					«ENDFOR»
				
			</application>
		
		</manifest>
		'''
		
	def static activity(String className, boolean isMain) '''
		«// TODO Generate
		»
		<activity name="«className»" android:name=".controller.«className»" android:label="@string/app_name">
			«IF isMain»
			<intent-filter>
				<action android:name="android.intent.action.MAIN" />
				<category android:name="android.intent.category.LAUNCHER" />
			</intent-filter> 
			«ENDIF»
		</activity>
	'''
		
}