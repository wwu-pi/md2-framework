package de.wwu.md2.framework.tests.dsl.controller.validator 

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
import static extension org.junit.Assert.*

import org.junit.Test
import org.eclipse.xtext.junit4.validation.ValidationTestHelperimport de.wwu.md2.framework.mD2.ControllerElement
import org.eclipse.emf.common.util.EList
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.Validator
import java.util.List

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ValidatorTests {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;
	MD2Model viewModel;
	MD2Model validatorControllerModel; 
	ResourceSet rs;
	private EList<ControllerElement> elements;
	private List<Validator> validators;


	//MISSING/TODO: Validators have to be linked with Viewelements -> this is neither done in the model 
	//nor in the tests

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		mainModel = BASIC_CONTROLLER_M.load.parse(rs);
		validatorControllerModel = VALIDATOR_COMPONENT_C.load.parse(rs);
		elements = elements = (validatorControllerModel.modelLayer as Controller).controllerElements;
		validators = elements.filter(typeof(Validator)).toList;
	}
	
	@Test
	def parseControllerValidatorTest(){
		validatorControllerModel.assertNoErrors;	
	} 
	
	@Test
	def validatorNamesTest(){
		"validateComplaintID".assertEquals(validators.get(0).name);
		"validateDesctription".assertEquals(validators.get(1).name);
		"validateUserEmail".assertEquals(validators.get(2).name);
		"validateDate".assertEquals(validators.get(3).name);
		"myRemoteValidator".assertEquals(validators.get(4).name);	
	}
	
	@Test
	def NumberOfValidatorsTest(){
		5.assertEquals(elements.filter(typeof(Validator)).size);	
	} 
	
}
