package de.wwu.md2.framework.tests.dsl.controller.webservicecall
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
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.ValidatorBindingTask
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.validation.ControllerValidator
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.WebServiceCall

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class WebServiceCallTests {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model viewModel;
	MD2Model viewModel2;
	MD2Model modelModel;
	MD2Model modelModel2;
	MD2Model ws_call_model;
	MD2Model ws_call_validator_model;
	ResourceSet rs;
	ResourceSet rs2;
	
	private EList<ControllerElement> elements;
	private List<WebServiceCall> webservicecalls;
	
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		modelModel = BASIC_CONTROLLER_M.load.parse(rs);
		ws_call_model = WS_CALL_C.load.parse(rs);
		
		rs2 = new ResourceSetImpl();
		viewModel2 = BASIC_CONTROLLER_V.load.parse(rs2);
		modelModel2 = BASIC_CONTROLLER_M.load.parse(rs2);
		ws_call_validator_model= WS_CALL_VALIDATOR_C.load.parse(rs2);
		elements = (ws_call_model.modelLayer as Controller).controllerElements;
		webservicecalls = elements.filter(typeof(WebServiceCall)).toList;
	}
	
	@Test
	def parseControllerValidatorTest(){
		modelModel.assertNoErrors;	
		viewModel.assertNoErrors;
		ws_call_model.assertNoErrors;
	} 
	
	
	/**
	 * Check if validator asserts error, i.e. check if validator recognizes when 
	 * in a webServiceCall bodyparams are specified although the method defined was GET 
	 */
	@Test
	def noBodyParamsAllowedWhenGETMethodTest(){
	    ws_call_validator_model.assertError(MD2Package::eINSTANCE.webServiceCall, ControllerValidator::NOBODYPARAMSWHENGET);
	}	
}
