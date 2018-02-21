package de.wwu.md2.framework.tests.dsl.workflow.validator

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
import de.wwu.md2.framework.validation.WorkflowValidator

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class validatorTest {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model workflowModel;
	MD2Model controllerModel;
	MD2Model viewModel;
	MD2Model modelModel;
	MD2Model workflowSuccessModel;
	MD2Model controllerSuccessModel;
	MD2Model viewSuccessModel;
	MD2Model modelSuccessModel;
	ResourceSet rs;
		
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		workflowModel = WORKFLOW_VALIDATOR_W.load.parse(rs);
		controllerModel = WORKFLOW_VALIDATOR_C.load.parse(rs);
		viewModel = WORKFLOW_VALIDATOR_V.load.parse(rs);
		modelModel = WORKFLOW_VALIDATOR_M.load.parse(rs);
		workflowSuccessModel = WORKFLOW_VALIDATOR_SUCCESS_W.load.parse(rs);
		controllerSuccessModel = WORKFLOW_VALIDATOR_SUCCESS_C.load.parse(rs);
		viewSuccessModel = WORKFLOW_VALIDATOR_SUCCESS_V.load.parse(rs);
		modelSuccessModel = WORKFLOW_VALIDATOR_SUCCESS_M.load.parse(rs);



	}
	
	/**
	 * Checks whether the validator throws an error if
	 * not all events of a worklowElement are handled in the corresponding
	 * workflowElementEntry.
	 */
	@Test
	def checkAllEventsOfWorkflowElementHandledTest(){
		workflowModel.assertError(MD2Package::eINSTANCE.workflowElementEntry,ControllerValidator::EVENTSINCONTROLLER)
	}
	
	/**
	 * Checks whether the validator throws an error if there are fireEventActions
	 * in the init block of a workflowElement.
	 */
	@Test
	def checkNoFireEventActionInInitBlockTest(){
		controllerModel.assertError(MD2Package::eINSTANCE.fireEventAction,ControllerValidator::EVENTININIT)
	}
	
	@Test
	def checkTerminateWorkflow_ErrorTest(){
		workflowModel.assertWarning(MD2Package::eINSTANCE.workflow, WorkflowValidator::WORKFLOWENDED)
	}	
	
	@Test	
	def checkTerminateWorkflow_SuccessTest(){
		workflowSuccessModel.assertNoWarnings(MD2Package::eINSTANCE.workflow, WorkflowValidator::WORKFLOWENDED)
	}	
}
