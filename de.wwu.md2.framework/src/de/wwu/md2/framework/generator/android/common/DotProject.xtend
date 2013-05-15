package de.wwu.md2.framework.generator.android.common

class DotProject {
	
	def static dotProject(String projectName) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<projectDescription>
			<name>«projectName»</name>
			<comment></comment>
			<projects>
			</projects>
			<buildSpec>
				<buildCommand>
					<name>com.android.ide.eclipse.adt.ResourceManagerBuilder</name>
					<arguments>
					</arguments>
				</buildCommand>
				<buildCommand>
					<name>com.android.ide.eclipse.adt.PreCompilerBuilder</name>
					<arguments>
					</arguments>
				</buildCommand>
				<buildCommand>
					<name>org.eclipse.jdt.core.javabuilder</name>
					<arguments>
					</arguments>
				</buildCommand>
				<buildCommand>
					<name>com.android.ide.eclipse.adt.ApkBuilder</name>
					<arguments>
					</arguments>
				</buildCommand>
			</buildSpec>
			<natures>
				<nature>com.android.ide.eclipse.adt.AndroidNature</nature>
				<nature>org.eclipse.jdt.core.javanature</nature>
			</natures>
		</projectDescription>
		'''
}