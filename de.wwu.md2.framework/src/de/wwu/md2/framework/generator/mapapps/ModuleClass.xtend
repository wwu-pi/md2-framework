package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class ModuleClass {
	
	def static generateModule(DataContainer dataContainer) '''
		define([
			«FOR customAction : dataContainer.customActions»
				"./actions/«customAction.name.toFirstUpper»",
			«ENDFOR»
			«FOR entity : dataContainer.entities»
				"./entities/«entity.name.toFirstUpper»",
			«ENDFOR»
			"./Controller",
			"ct/Stateful"
		], {});
	'''
}
