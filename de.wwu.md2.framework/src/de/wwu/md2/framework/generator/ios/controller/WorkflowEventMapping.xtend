package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.WorkflowEvent

class WorkflowEventMapping {
	
	static def generateClass(View view) '''
	TODO
	«view.viewElements.length»
	'''
	
	// Lookup real widget name for 
	def static lookup(WorkflowEvent event) {
		// TODO WFEName_EventName
		return event.name;
	}
}