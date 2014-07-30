package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class ModuleClass {
	
	def static String generateModule(DataContainer dataContainer) '''
		define([
			"ct/Stateful",
			«FOR contentProvider : dataContainer.contentProviders»
				"./contentproviders/«contentProvider.name.toFirstUpper»",
			«ENDFOR»
			"./Controller",
			"./CustomActions",
			"./Entities"
		], {});
	'''
}
