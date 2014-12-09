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
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.ValidatorBindingTask

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ValidatorTests {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;
	MD2Model viewModel;
	MD2Model rootValidatorModel; 
	MD2Model inputFieldValidatorModel; 
	ResourceSet rs;
	
	private EList<ControllerElement> elements;
	private List<Validator> validators;
	
	private EList<ControllerElement> ifv_elements;
	private List<CustomAction> actions;
	private List<ValidatorBindingTask> tasks;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		mainModel = BASIC_CONTROLLER_M.load.parse(rs);
		rootValidatorModel = VALIDATOR_COMPONENT_C.load.parse(rs);
		inputFieldValidatorModel = INPUT_FIELD_VALIDATOR_COMPONENT_C.load.parse(rs);
		
		elements = (rootValidatorModel.modelLayer as Controller).controllerElements;
		validators = elements.filter(typeof(Validator)).toList;
		
		ifv_elements = (inputFieldValidatorModel.modelLayer as Controller).controllerElements;
		actions = ifv_elements.filter(typeof(CustomAction)).toList;
		tasks = actions.get(0).codeFragments.filter(typeof(ValidatorBindingTask)).toList;
	
	}
	
	@Test
	def parseControllerValidatorTest(){
		rootValidatorModel.assertNoErrors;	
		inputFieldValidatorModel.assertNoErrors;
	} 
	
	//Tests for validators specified as direct sub elements of controller
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

	//Tests for validators directly defined while binding them to input fields
	@Test
	def NumberOfActionsAndTasksInActionsTest(){
		1.assertEquals(actions.size);
		4.assertEquals(actions.get(0).codeFragments.filter(typeof(ValidatorBindingTask)).size);	
	} 
	
	@Test
	def bindingtaskToInputFieldTest(){
		"complaintID".assertEquals(tasks.get(0).referencedFields.get(0).ref.name);
		"descriptionTxt".assertEquals(tasks.get(1).referencedFields.get(0).ref.name);
		"userEmail".assertEquals(tasks.get(2).referencedFields.get(0).ref.name);
		"submitDate".assertEquals(tasks.get(3).referencedFields.get(0).ref.name);		
	} 
	
		
	@Test
	def numberOfValidatorsPerBindingtaskTest(){
		2.assertEquals(tasks.get(0).validators.size);
		1.assertEquals(tasks.get(1).validators.size);
		1.assertEquals(tasks.get(2).validators.size);
		1.assertEquals(tasks.get(3).validators.size);
	} 
	
	
}
