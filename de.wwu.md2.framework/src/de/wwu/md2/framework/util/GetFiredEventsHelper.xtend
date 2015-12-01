package de.wwu.md2.framework.util;

import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.FireEventAction

public class GetFiredEventsHelper {
	
	/**
	 * Calculate the set of all Workflow Events that are fired by actions in a Workflow Element
	 */
	def getFiredEvents(WorkflowElement wfe) {
		
		// get all code fragments of actions
		val actions = wfe.actions.
			filter(CustomAction)
		
		// filter eAllContents for fireEventActions
		val fireEventActions = actions.map[a|a.eAllContents.toIterable].flatten.filter(typeof(FireEventAction))
			
		// compute actually fired events
		return fireEventActions.map[ event | event.workflowEvent ].toSet
		
	}
}
