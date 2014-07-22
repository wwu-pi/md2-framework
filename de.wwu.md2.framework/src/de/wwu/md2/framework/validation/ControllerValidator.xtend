package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.MD2Package
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

/**
 * Valaidators for all controller elements of MD2.
 */
class ControllerValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    
    /////////////////////////////////////////////////////////
	/// Action Validators
	/////////////////////////////////////////////////////////
	
	
	/**
	 * Ensures that the operations 'save' and 'remove' can only be used for none-read-only content providers
	 * in the ContentProviderOperationAction.
	 */
	@Check
	def checkOnlyReadParameterForReadOnlyContentProviderOperations(ContentProviderOperationAction action) {
		
		val abstractProviderReference = action.contentProvider
		val isReadOnly = switch (abstractProviderReference) {
			ContentProviderReference: abstractProviderReference.contentProvider.readonly
			LocationProviderReference: true
		}
		
		if (isReadOnly && !action.operation.equals(AllowedOperation::READ)) {
			val error = '''
				You tried to apply a '«action.operation»'-operation on a read-only content provider. Only 'load' is allowed in this location.
			'''
			acceptError(error, action, MD2Package.eINSTANCE.contentProviderOperationAction_Operation, -1, null);
		}
	}
	
}
