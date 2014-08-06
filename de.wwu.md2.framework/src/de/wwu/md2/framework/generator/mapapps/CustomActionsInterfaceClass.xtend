package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

class CustomActionsInterfaceClass {
	
	def static String generateCustomActionsInterface(DataContainer dataContainer) '''
		define([
			«val imports = newArrayList('''"dojo/_base/declare"''', generateActionImports(dataContainer))»
			«FOR importStr : imports.filter(s | !s.toString.trim.empty) SEPARATOR ","»
				«importStr»
			«ENDFOR»
		],
		function(
			«val importParams = newArrayList("declare", generateActionImportParams(dataContainer))»
			«FOR paramStr : importParams.filter(s | !s.toString.trim.empty) SEPARATOR ","»
				«paramStr»
			«ENDFOR»
		) {
			
			return declare([], {
				
				/**
				 * Provide an array with instances of all actions.
				 */
				createInstance: function() {
					return [
						«FOR customAction : dataContainer.customActions SEPARATOR ","»
							 new «customAction.name»()
						«ENDFOR»
					];
				}
				
			});
		});
	'''
	
	private def static generateActionImports(DataContainer dataContainer) '''
		«FOR customAction : dataContainer.customActions SEPARATOR ","»
			"./actions/«customAction.name.toFirstUpper»"
		«ENDFOR»
	'''
	
	private def static generateActionImportParams(DataContainer dataContainer) '''
		«FOR customAction : dataContainer.customActions SEPARATOR ","»
			«customAction.name»
		«ENDFOR»
	'''
}