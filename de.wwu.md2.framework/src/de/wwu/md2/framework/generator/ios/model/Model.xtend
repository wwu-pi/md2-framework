package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.Entity

class Model {
	
	def static generateEntity(Entity entity) '''
		«entity.name»
	'''
	
}