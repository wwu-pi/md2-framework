package de.wwu.md2.framework.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check

import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.FireEventEntry

import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.MD2Package


/**
 * Validators for all workflow elements of MD2.
 */

class WorkflowValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String WORKFLOWENDED = "WorkflowEnded";
    
	@Check
	def checkWorkflowThrowsEndEvent(Workflow workflow){
		var wfes = workflow.workflowElementEntries;
		var fireEventEntries = wfes.map[wf| wf.firedEvents].flatten;
		var workflowEnded = false;
		
		for(FireEventEntry fee : fireEventEntries){
			if (fee.endWorkflow){
				workflowEnded = true;
			}
		}
		if(workflowEnded == false){
			acceptWarning("The Workflow should be finished at some point", workflow, null, -1, WORKFLOWENDED)
		}
	}
		
		
    public static final String INVOKEEVENTDESCMAYNOTBEEMPTY = "invokeEventDescMayNotBeEmpty"
    public static final String INVOKEHASTOBEINVOKEABLE = "invokeHasToBeInvokeable"
    public static final String INVOKEMAYNOTBEINVOKEABLE = "invokeMayNotBeInvokeable"
    
	/////////////////////////////////////////////////////////
	/// Invoke Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Avoids that an empty string is inserted as eventDesc within the invoke part of an workflow element entry
	 */
	@Check
	def checkThatEventDescNotEmpty(WorkflowElementEntry wfeEntry) {
		
		if (wfeEntry.eventDesc == ""){
			val error = '''An empty string as event description for invoking the workflow element is not allowed.'''
			acceptError(error, wfeEntry, MD2Package.eINSTANCE.workflowElementEntry_EventDesc , -1, INVOKEEVENTDESCMAYNOTBEEMPTY);
		}
	}
	
	/**
	 * Ensure that "invoke" is used in both model parts
	 */
	@Check
	def checkThatInvokeIsUsedInBothModelParts(WorkflowElementEntry wfeEntry) {
		val wfe = wfeEntry.workflowElement
		if (wfe.invoke.size==0 && wfeEntry.invokable){
			val error = '''The workflow element is set invokeable, but does not specify invoke structures in the controller model part.'''
			acceptError(error, wfeEntry, MD2Package.eINSTANCE.workflowElementEntry_Invokable , -1, INVOKEMAYNOTBEINVOKEABLE);
		}
		if (wfe.invoke.size>0 && !wfeEntry.invokable){
			val error = '''The workflow element is not set invokeable, but has invoke structures specified in the controller model part.'''
			acceptError(error, wfeEntry, MD2Package.eINSTANCE.workflowElementEntry_WorkflowElement , -1, INVOKEHASTOBEINVOKEABLE);
		}
	}
}
