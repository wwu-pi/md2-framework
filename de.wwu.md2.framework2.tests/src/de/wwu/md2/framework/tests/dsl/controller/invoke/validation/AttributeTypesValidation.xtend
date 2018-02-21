package de.wwu.md2.framework.tests.dsl.controller.invoke.validation

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.Before
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*

import org.junit.Test
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import de.wwu.md2.framework.validation.ControllerValidator
import de.wwu.md2.framework.mD2.MD2Package

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class AttributeTypesValidation {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;
	MD2Model viewModel;
	MD2Model workflowModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		mainModel = INVOKE_ATTRIBUTETYPE_M.load.parse(rs);
		workflowModel = INVOKE_W.load.parse(rs);
	}
	
	/**
	 * Type missmatch string float
	 */
	@Test
	def testRequireAttribute1Validator(){
		var controllerModel = INVOKE_ATTRIBUTETYPE1_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefaultValue,ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
	
	/**
	 * Type missmatch float date
	 */
	@Test
	def testRequireAttribute2Validator(){
		var controllerModel = INVOKE_ATTRIBUTETYPE2_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefaultValue,ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
	/**
	 * Type missmatch date string
	 */
	@Test
	def testRequireAttribute3Validator(){
		var controllerModel = INVOKE_ATTRIBUTETYPE3_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefaultValue,ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
	/**
	 * Type missmatch time float
	 */
	@Test
	def testRequireAttribute4Validator(){
		var controllerModel = INVOKE_ATTRIBUTETYPE4_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefaultValue,ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
	/**
	 * Type missmatch integer time
	 */
	@Test
	def testRequireAttribute5Validator(){
		var controllerModel = INVOKE_ATTRIBUTETYPE5_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefaultValue,ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
	/**
	 * No type missmatch
	 */
	@Test
	def testRequireAttributeWorkingValidator(){
		var controllerModel = INVOKE_ATTRIBUTETYPEWORKING_C.load.parse(rs);
		controllerModel.assertNoError(ControllerValidator::INVOKEDEFAULTVALUETYPEMISSMATCH);		
	} 
}
