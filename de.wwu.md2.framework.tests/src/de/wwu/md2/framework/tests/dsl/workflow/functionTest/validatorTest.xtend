package de.wwu.md2.framework.tests.dsl.workflow.functionTest

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
class validatorTest {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model workflowModel;
	MD2Model controllerModel;
	MD2Model viewModel;
	MD2Model modelModel;
		ResourceSet rs;
		
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		workflowModel = WORKFLOW_VALIDATOR_W.load.parse(rs);
		controllerModel = WORKFLOW_VALIDATOR_C.load.parse(rs);
		viewModel = WORKFLOW_VALIDATOR_V.load.parse(rs);
		modelModel = WORKFLOW_VALIDATOR_M.load.parse(rs);
	}
	
	@Test
	def checkIfSpecifiedEventsAreFiredInControllerTest(){
		workflowModel.assertNoErrors();
		//workflowModel.assertNoIssues();
		workflowModel.assertWarning(MD2Package::eINSTANCE.workflowEvent,ControllerValidator::FIREEVENT)
	}
	
	@Test
	def checkEventExistsInCorrectWorkflowElementTest(){
		//controllerModel.assertNoErrors();
		//controllerModel.assertNoIssues();
		controllerModel.assertError(MD2Package::eINSTANCE.fireEventAction,ControllerValidator::EVENTREFERENCE);
	}
	
}