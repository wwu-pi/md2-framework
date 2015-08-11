package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.Entity

class iosEntity {
	
	def static generateClass(Entity entity) '''
		«entity.name»
	'''
	
}