package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class ModuleClass {
	
	def static String generateModuleForModels() '''
		define([
			"./Models"
		], {});
	'''
	
	
	def static String generateModuleForContentProviders(DataContainer dataContainer) '''
		define([
			«FOR contentProvider : dataContainer.contentProviders SEPARATOR "," »
				"./contentproviders/«contentProvider.name.toFirstUpper»"
			«ENDFOR»
		], {});
	'''
	
	
	def static String generateModuleForWorkflowElement() '''
		define([
			"ct/Stateful",
			"./Controller",
			"./CustomActions"
		], {});
	'''
	
	def static String generateModuleForWorkflowHandler() '''
		define([
			"ct/Stateful",
			"./WorkflowEventHandler"
		], {});
	'''
}
