package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.Main

class ArraysXml {
	def static generateArraysXml(Iterable<Enum> enums) '''
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
		
			«FOR curEnum : enums»
			<string-array name="enum_«curEnum.name.toFirstLower»">
				«FOR elem : curEnum.enumBody.elements»
				<item>«elem»</item>
			«	ENDFOR»
			</string-array>
			
			«ENDFOR»
		
		</resources>
	'''
	def static generateStringsXml(Main mainElem) '''
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
		
			<string name="app_name">«mainElem.appName»</string>
		
		</resources>
	'''
}