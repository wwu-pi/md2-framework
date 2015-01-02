package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CustomAction

class CustomActionsInterfaceClass {
	
	def static String generateCustomActionsInterface(DataContainer dataContainer, WorkflowElement wfe) '''
		define([
			«val imports = newArrayList('''"dojo/_base/declare"''', generateActionImports(wfe))»
			«FOR importStr : imports.filter(s | !s.toString.trim.empty) SEPARATOR ","»
				«importStr»
			«ENDFOR»
		],
		function(
			«val importParams = newArrayList("declare", generateActionImportParams(wfe))»
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
						«FOR customAction : wfe.eAllContents.filter(CustomAction).toList SEPARATOR ","»
							 new «customAction.name»()
						«ENDFOR»
					];
				}
				
			});
		});
	'''
	
	private def static generateActionImports(WorkflowElement wfe) '''
		«FOR customAction : wfe.eAllContents.filter(CustomAction).toList SEPARATOR ","»
			"./actions/«customAction.name.toFirstUpper»"
		«ENDFOR»
	'''
	
	private def static generateActionImportParams(WorkflowElement wfe) '''
		«FOR customAction : wfe.eAllContents.filter(CustomAction).toList SEPARATOR ","»
			«customAction.name»
		«ENDFOR»
	'''
}