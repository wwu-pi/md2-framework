package de.wwu.md2.framework.tests.dsl.model.validator

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import de.wwu.md2.framework.mD2.MD2Model
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import org.junit.Before
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImplimport de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.validation.ModelValidator

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Validator_Model_Test {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model defaultReferenceValue
	MD2Model entityEnumUppercase
	MD2Model attributeLowercase
	MD2Model repeatedParameter
	MD2Model unsupportedFeatures
	MD2Model underscoreWithinEntityName
	MD2Model reservedNameWithinEntity
	
	ResourceSet rs
	
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		defaultReferenceValue = VALIDATOR_MODEL_M.load.parse(rs)
		entityEnumUppercase = MODEL_VALIDATOR_UPPERCASE_ENTITY.load.parse
		attributeLowercase = MODEL_VALIDATOR_LOWERCASE_ATTRIBUTE.load.parse
		repeatedParameter = MODEL_VALIDATOR_REPEATED_PARAMETERS.load.parse
		unsupportedFeatures = MODEL_VALIDATOR_UNSUPPORTED_FEATURES.load.parse
		underscoreWithinEntityName = MODEL_VALIDATOR_UNDERSCORE_ENTITY.load.parse
		reservedNameWithinEntity = MODEL_VALIDATOR_RESERVEDNAME_ENTITY.load.parse
	}
	
	/**
	 * Checks whether the error for defaults assigned to entities is thrown.
	 */
	@Test
	def defaultValueForReferenceTest() {
		defaultReferenceValue.assertError(MD2Package::eINSTANCE.attrEnumDefault, ModelValidator::DEFAULTREFERENCEVALUE)
	}
	
	/**
	 * Checks whether the error for a non-capitalized entity is thrown. 
	 */
	@Test
	def checkEntitiesStartsWithCapitalTest() {
	    entityEnumUppercase.assertWarning(MD2Package::eINSTANCE.modelElement, ModelValidator::ENTITYENUMUPPERCASE)
	}
	
	/**
	 * Checks whether the error for capitalized attributes is thrown.
	 */
	@Test
	def checkAttributeStartsWithCapitalTest() {
	    attributeLowercase.assertWarning(MD2Package::eINSTANCE.attribute, ModelValidator::ATTRIBUTELOWERCASE)
	}
	
	/**
	 * Checks whether the error for repeated declarations of parameters is thrown.
	 */
	@Test
	def checkRepeatedParamsTest() {
        //repeatedParameter.assertNoErrors
	    repeatedParameter.assertError(MD2Package::eINSTANCE.attributeType, ModelValidator::REPEATEDPARAMS)
	}
	
	/**
	 * Checks whether the warning for unsupported language features is thrown.
	 */
	@Test
	def checkAttributeTypeParam() {
	    unsupportedFeatures.assertWarning(MD2Package::eINSTANCE.attributeTypeParam, ModelValidator::UNSUPPORTEDPARAMTYPE)
	}
	
	/**
	 * Checks whether the error for underscores at the beginning of entities is thrown.
	 */
	 @Test
	 def checkUnderscoreEntityNameValidator(){
	 	underscoreWithinEntityName.assertError(MD2Package::eINSTANCE.modelElement, ModelValidator::ENTITYWITHOUTUNDERSCORE)
	 }
	 
	 /**
	 * Checks whether the error for preset Names as entities is thrown.
	 */
	 @Test
	 def checkPresetIdentifiersAsEntityNameValidator(){
	 	reservedNameWithinEntity.assertError(MD2Package::eINSTANCE.modelElement, ModelValidator::ENTITYWITHRESERVEDNAME)
	 }
}
