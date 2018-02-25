package de.wwu.md2.framework.validation

import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import org.eclipse.xtext.validation.Check

/**
 * Validators for all workflow elements of MD2.
 */

class WorkflowValidator extends AbstractMD2Validator {
	
    public static final String WORKFLOWENDED = "WorkflowEnded";
    
	@Check
	def checkWorkflowThrowsEndEvent(Workflow workflow){
		var wfes = workflow.workflowElementEntries;
		var fireEventEntries = wfes.map[wf| wf.firedEvents].flatten;
		
		if(!fireEventEntries.exists[it.endWorkflow]){
			warning("The Workflow should be finished at some point", 
				MD2Package.eINSTANCE.workflow_WorkflowElementEntries,
				WORKFLOWENDED)
		}
	}
	
    public static final String INVOKEEVENTDESCMAYNOTBEEMPTY = "invokeEventDescMayNotBeEmpty"
    public static final String INVOKEHASTOBEINVOKABLE = "invokeHasToBeInvokable"
    public static final String INVOKEMAYNOTBEINVOKABLE = "invokeMayNotBeInvokable"
    
	/////////////////////////////////////////////////////////
	/// Invocation Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Avoids that an empty string is inserted as eventDesc within the invoke part of an workflow element entry
	 */
	@Check
	def checkThatEventDescNotEmpty(WorkflowElementEntry wfeEntry) {
		if (wfeEntry.eventDesc == ""){
			error("An empty string as event description for invoking the workflow element is not allowed.",
				MD2Package.eINSTANCE.workflowElementEntry_EventDesc, 
				INVOKEEVENTDESCMAYNOTBEEMPTY);
		}
	}
	
	/**
	 * Ensure that "invoke" is used in both model parts
	 */
	@Check
	def checkThatInvokeIsUsedInBothModelParts(WorkflowElementEntry wfeEntry) {
		val wfe = wfeEntry.workflowElement
		if (wfe.invoke.size==0 && wfeEntry.invokable){
			error("The workflow element is set invokable, but does not specify invoke structures in the controller model part.", 
				MD2Package.eINSTANCE.workflowElementEntry_Invokable,
				INVOKEMAYNOTBEINVOKABLE)
		}
		if (wfe.invoke.size>0 && !wfeEntry.invokable){
			error("The workflow element is not set invokable, but has invoke structures specified in the controller model part.", 
				MD2Package.eINSTANCE.workflowElementEntry_WorkflowElement,
				INVOKEHASTOBEINVOKABLE)
		}
	}
}
