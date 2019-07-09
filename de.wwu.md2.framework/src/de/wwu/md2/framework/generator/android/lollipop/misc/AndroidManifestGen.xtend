package de.wwu.md2.framework.generator.android.lollipop.misc

import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.ViewFrame

class AndroidManifestGen {	
	
	// generates android manifest for the project
	def static String generateProjectAndroidManifest(App app, Iterable<ViewFrame> rootViews, String packageName)'''
		<?xml version="1.0" encoding="utf-8"?>
		<!-- generated in de.wwu.md2.framework.generator.android.lollipop.misc.AndroidManifest.generateProjectAndroidManifest() -->
		<manifest xmlns:android="http://schemas.android.com/apk/res/android" 
		    package="«packageName»" >
		    
		    <uses-permission android:name="android.permission.INTERNET" />
		    
		    <application
		        android:name=".«app.name»"
		        android:allowBackup="true"
		        android:icon="@mipmap/ic_launcher"
		        android:label="@string/app_name"
		        android:theme="@style/AppTheme" >
		        	<provider
		        		android:name="android.support.v4.content.FileProvider"
		        		android:authorities="de.wwu.md2.android.md2library.model.contentProvider.fileprovider"
		        		android:exported="false"
		        		android:grantUriPermissions="true">
		        		<meta-data
		        			android:name="android.support.FILE_PROVIDER_PATHS"
		        			android:resource="@xml/file_provider_paths"></meta-data>
		        	</provider>
					<activity
			            android:name=".StartActivity"
			            android:label="@string/app_name" >
			            <intent-filter>
			                <action android:name="android.intent.action.MAIN" />			
			                <category android:name="android.intent.category.LAUNCHER" />
			            </intent-filter>
			        </activity>
		        «FOR rv : rootViews»
		        	<activity
		        		android:name=".«rv.name.toFirstUpper»Activity"
		        		android:label="@string/title_activity_«rv.name.toFirstLower»" >
		        	</activity>
		        «ENDFOR»
		    </application>
		</manifest>
	'''
}