package de.wwu.md2.framework.generator.android.common

class DotClassPath {
	
	def static dotClassPath() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<classpath>
			<classpathentry kind="src" path="src"/>
			<classpathentry kind="src" path="gen"/>
			<classpathentry kind="con" path="com.android.ide.eclipse.adt.ANDROID_FRAMEWORK"/>
			<classpathentry kind="con" path="com.android.ide.eclipse.adt.LIBRARIES"/>
			<classpathentry exported="true" kind="lib" path="lib/guava-10.0.1.jar"/>
			<classpathentry exported="true" kind="lib" path="lib/jackson-all-1.9.9.jar"/>
			<classpathentry exported="true" kind="lib" path="lib/md2-android-lib.jar"/>
			<classpathentry kind="output" path="bin/classes"/>
		</classpath>
		'''
	
}