package de.wwu.md2.framework.scoping;

import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.FireEventAction

public class MD2ScopingHelper {
	
	/**
	 * Calculate the set of all Workflow Events that are fired by actions in a Workflow Element
	 */
	def getFiredEvents(WorkflowElement wfe) {
		
		// get all code fragments of actions
		val allFragments = wfe.actions.
			filter(CustomAction).
			map[ action |
				action.codeFragments
			].flatten
		
		
		// get all actions
		val bindingActions = allFragments.filter(EventBindingTask).map[ task | 
			task.actions].flatten
		val unbindingActions = allFragments.filter(EventUnbindTask).map[ task | 
			task.actions].flatten
		val callActions = allFragments.filter(CallTask).map[ task | 
			task.action]
			
		// combine the three lists
		val allActions = bindingActions + unbindingActions + callActions
		
		
		// filter for fireEventActions
		val fireEventActions = allActions.filter(SimpleActionRef).map[simpleAction |
				simpleAction.action ].filter(FireEventAction)
			
		// compute actually fired events
		return fireEventActions.map[ event | event.workflowEvent ].toSet
		
	}
}
