package de.wwu.md2.framework.android.lollipop.validation

import de.wwu.md2.framework.validation.AbstractMD2JavaValidator
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class AndroidLollipopValidator extends AbstractMD2JavaValidator{

	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String WORKFLOWENDED = "WorkflowEnded";
    
	@Check
	def checkWorkflowThrowsEndEvent(){
		
	}
	
}