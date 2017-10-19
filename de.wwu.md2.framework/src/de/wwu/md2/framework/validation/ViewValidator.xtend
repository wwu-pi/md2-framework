package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.ViewFrame
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

/**
 * Valaidators for all view elements of MD2.
 */
class ViewValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    
    /////////////////////////////////////////////////////////
	/// Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Ensures only one default proceed/back action exists per ViewFrame
	 */
	@Check
	def checkViewActions(ViewFrame frame){
		if(frame.viewActions.filter[va | va.defaultBack === true].length > 1){
			acceptWarning("More than one default back action specified",
				frame.viewActions.filter[va | va.defaultBack === true].get(1), MD2Package.VIEW_ACTION__DEFAULT_BACK, -1, null);
		}

		if(frame.viewActions.filter[va | va.defaultProceed === true].length > 1){
			acceptWarning("More than one default back action specified",
				frame.viewActions.filter[va | va.defaultProceed === true].get(1), MD2Package.VIEW_ACTION__DEFAULT_PROCEED, -1, null);
		}
	}

	    
}
