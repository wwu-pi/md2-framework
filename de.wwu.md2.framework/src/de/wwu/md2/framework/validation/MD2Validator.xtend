/*
 * generated by Xtext 2.13.0
 */
package de.wwu.md2.framework.validation

import org.eclipse.xtext.validation.ComposedChecks
import org.eclipse.xtext.validation.NamesAreUniqueValidator

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
 @ComposedChecks(validators= #[
	NamesAreUniqueValidator,
	ProjectValidator,
	ControllerValidator,
	ModelValidator,
	ViewValidator,
	WorkflowValidator,
	AccessibilityVisionValidator
	//AndroidLollipopValidator,
	//IOSValidator
])
class MD2Validator extends AbstractMD2Validator {
	
	// Validation delegated to referenced classes
	
}
