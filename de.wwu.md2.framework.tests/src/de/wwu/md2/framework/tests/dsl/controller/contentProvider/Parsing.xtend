package de.wwu.md2.framework.tests.dsl.controller.contentProvider

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.emf.ecore.resource.ResourceSet
import de.wwu.md2.framework.mD2.ControllerElement
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.Before
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import static extension org.junit.Assert.*
import de.wwu.md2.framework.mD2.Controller
import org.junit.Test

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Parsing {

	@Inject extension ParseHelper<MD2Model>
	MD2Model mainModel;
	MD2Model viewModel;
	ResourceSet rs;

	private EList<ControllerElement> elements;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		viewModel = BASIC_CONTROLLER_V.load.parse(rs);
		mainModel = BASIC_CONTROLLER_V.load.parse(rs);
		elements = (mainModel.modelLayer as Controller).controllerElements;
	}
	
	@Test
	def dummyTest(){
		
	} 
}
