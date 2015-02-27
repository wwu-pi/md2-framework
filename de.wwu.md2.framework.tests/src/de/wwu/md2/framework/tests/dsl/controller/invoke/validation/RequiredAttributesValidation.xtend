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
class RequiredAttributesValidation {

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
		mainModel = INVOKE_REQUIREDATTRIBUTE_M.load.parse(rs);
		workflowModel = INVOKE_W.load.parse(rs);
	}
	
	/**
	 * One required attribute is not set
	 */
	@Test
	def testRequireAttribute1Validator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTE1_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
	
	/**
	 * One referenced attribute is not set
	 */
	@Test
	def testRequireAttribute2Validator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTE2_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
	
	/**
	 * One required attribute of a required nested referenced attribute is not set
	 */
	@Test
	def testRequireAttribute3Validator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTE3_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
	
	/**
	 * One required attribute of a optional nested referenced attribute is not set
	 */
	@Test
	def testRequireAttribute4Validator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTE4_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
	
	/**
	 * All required attributes are set, but not the optional
	 */
	@Test
	def testRequireAttributeWorkingValidator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTEWORKING_C.load.parse(rs);
		controllerModel.assertNoError(ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
}
