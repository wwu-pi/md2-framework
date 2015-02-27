package de.wwu.md2.framework.tests.dsl.workflow.invoke

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
import de.wwu.md2.framework.validation.WorkflowValidator
import de.wwu.md2.framework.mD2.MD2Package

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Validation {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;
	MD2Model viewModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		mainModel = BASIC_CONTROLLER_M.load.parse(rs);
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		
	}
	
	/**
	 * Tests if an error is thrown, when the controller specifies invoke definitions in the workflow element, 
	 * but the workflow does not define that workflow element as invokable.
	 */
	@Test
	def testInvokeOnBothSides1Validator(){
		INVOKE_ONBOTHSIDES1_C.load.parse(rs);
		var workflowModel = INVOKE_ONBOTHSIDES_W.load.parse(rs);
		workflowModel.assertError(MD2Package::eINSTANCE.workflowElementEntry,WorkflowValidator::INVOKEHASTOBEINVOKEABLE);		
	} 
	
	/**
	 * Tests if an error is thrown, when the controller specifies no invoke definitions in the workflow element, 
	 * but the workflow does define that workflow element as invokable.
	*/
	@Test
	def testInvokeOnBothSides2Validator(){
		INVOKE_ONBOTHSIDES2_C.load.parse(rs);
		var workflowModel = INVOKE_ONBOTHSIDES_W.load.parse(rs);
		workflowModel.assertError(MD2Package::eINSTANCE.workflowElementEntry,WorkflowValidator::INVOKEMAYNOTBEINVOKEABLE);		
	} 

}
