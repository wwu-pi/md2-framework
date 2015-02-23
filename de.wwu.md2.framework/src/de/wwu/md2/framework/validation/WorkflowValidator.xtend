package de.wwu.md2.framework.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check

import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.FireEventEntry

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
}