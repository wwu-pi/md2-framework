package de.wwu.md2.framework.tests.dsl.view.contentContainer

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
class ContentContainerParser {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	ResourceSet rs;	
	
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
	}
	
	@Test
	def gridLayoutTest(){
		var flowLayoutModel = CONTENT_CONTAINER_GRID_LAYOUT_V.load.parse(rs);
		flowLayoutModel.assertNoErrors;		
	}
	
	@Test
	def flowLayoutTest(){
		var flowLayoutModel = CONTENT_CONTAINER_FLOW_LAYOUT_V.load.parse(rs);
		flowLayoutModel.assertNoErrors;		
	}
}