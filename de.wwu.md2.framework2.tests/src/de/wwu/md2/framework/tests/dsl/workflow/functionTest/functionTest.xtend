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

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class FunctionTest {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model workflowModel;
	MD2Model controllerModel;
	MD2Model modelModel;
	MD2Model viewModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		workflowModel = WORKFLOW_FUNCTION_W.load.parse(rs);
		controllerModel = WORKFLOW_FUNCTION_C.load.parse(rs);
		viewModel = WORKFLOW_FUNCTION_V.load.parse(rs);
		modelModel =  WORKFLOW_FUNCTION_M.load.parse(rs);
	}
	
	@Test
	def simpleWorkflowTest(){
		workflowModel.assertNoErrors;
		controllerModel.assertNoErrors;
		viewModel.assertNoErrors;
		modelModel.assertNoErrors;
	}	
}
