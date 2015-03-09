package de.wwu.md2.framework.validation;

import org.eclipse.xtext.validation.ComposedChecks;

/**
 * <p>Be aware that the Literal interface is not generated anymore as our Xtext grammar grew too big and
 * thus it is not possible to access the structural features as described in the Xtext documentation. E.g.,
 * MD2Package.Literals.MD2_MODEL__PACKAGE does not work anymore. Use MD2Package.eInstance.getEClass_Feature
 * instead.</p>
 * 
 * <p>Comment of Sebastian Zarnekow at Itemis concerning this matter:</p>
 * <p>"if your EPackage becomes too large, the Literals may be skipped by the genmodel generator
 * because it may exceed the maximum size for class files. You may want to use
 * MyDslPackage.eInstance.getClassName_FeatureName instead.</p>
 */
@ComposedChecks(validators= {
	LegacyValidator.class,
	ProjectValidator.class,
	ControllerValidator.class,
	ModelValidator.class,
	ViewValidator.class,
	WorkflowValidator.class
})
public class MD2JavaValidator extends AbstractMD2JavaValidator {
	
	// All validators are specified in the classes ControllerValidator, ViewValidator
	// and ModelValidator.
	// 
	// The LegacyValidator contains all checks that were implemented before splitting
	// this file and should be refactored to the respective Xtend code over time.
	
}
