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

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Parsing {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;
	MD2Model viewModel;
	MD2Model controllerModel;
	MD2Model workflowModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		mainModel = BASIC_CONTROLLER_M.load.parse(rs);
		controllerModel = INVOKE_C.load.parse(rs);
		workflowModel = INVOKE_W.load.parse(rs);
		controllerModel = INVOKE_C.load.parse(rs);
	}
	
	@Test
	def testWorkingInvokeScenario(){
		controllerModel.assertNoErrors;		
		workflowModel.assertNoErrors;		
	} 
}
