package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.Enum

class iosEnum {
	
	def static generateClass(Enum enumInstance) '''
		«enumInstance.name»
	'''
	
}