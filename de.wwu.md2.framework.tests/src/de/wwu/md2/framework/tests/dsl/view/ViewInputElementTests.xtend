package de.wwu.md2.framework.tests.dsl.view

import com.google.inject.Inject
import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ViewInputElementTests {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	
	MD2Model viewModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = VIEW_INPUT_ELEMENTS_ENTITY.load.parse(rs);
		viewModel = VIEW_INPUT_ELEMENTS_CONTROLLER.load.parse(rs);
		viewModel = VIEW_INPUT_ELEMENTS.load.parse(rs);
	}
		
	@Test
	def simpleWorkflowTest(){
		viewModel.assertNoErrors;
	}
}