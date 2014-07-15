package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class ModuleClass {
	
	def static generateModule(DataContainer dataContainer) '''
		define([
			"ct/Stateful",
			«FOR customAction : dataContainer.customActions SEPARATOR ","»
				"./actions/«customAction.name.toFirstUpper»"
			«ENDFOR»
		], {});
	'''
}
