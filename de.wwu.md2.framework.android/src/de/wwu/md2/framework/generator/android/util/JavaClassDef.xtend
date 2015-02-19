package de.wwu.md2.framework.generator.android.util

import org.eclipse.xtend.lib.Property

class JavaClassDef {
	@Property String simpleName
	@Property String basePackage
	@Property String subPackage
	@Property CharSequence contents
	
	def getName() {
		fullPackage + "." + simpleName
	}
	
	def getFileName() {
		basePackage + "/src/" + name.replace('.', '/') + ".java"
	}
	
	def void setSimpleName(String value) {
		_simpleName = value.toFirstUpper
	}
	
	def getFullPackage() {
		basePackage + "." + subPackage
	}
}