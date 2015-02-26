package de.wwu.md2.framework.tests.dsl.controller.invoke

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
class Validation {

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
		mainModel = BASIC_CONTROLLER_M.load.parse(rs);
		workflowModel = INVOKE_W.load.parse(rs);
	}
	
	@Test
	def testRequireAttributeValidator(){
		var controllerModel = INVOKE_REQUIREDATTRIBUTE_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEMISSINGREQUIREDATTRIBUTE);		
	} 
	@Test
	def testPathCollision1Validator(){
		var controllerModel = INVOKE_PATHCOLLISION1_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEPATHCOLLISION);
	} 
	@Test
	def testPathCollision2Validator(){
		var controllerModel = INVOKE_PATHCOLLISION2_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEPATHCOLLISION);		
	}
	@Test
	def testPathCollision3Validator(){
		var controllerModel = INVOKE_PATHCOLLISION3_C.load.parse(rs);
		controllerModel.assertError(MD2Package::eINSTANCE.invokeDefinition,ControllerValidator::INVOKEPATHCOLLISION);		
	} 
}
