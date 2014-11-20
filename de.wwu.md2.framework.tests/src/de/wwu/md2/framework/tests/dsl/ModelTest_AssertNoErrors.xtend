package de.wwu.md2.framework.tests.dsl

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import de.wwu.md2.framework.mD2.MD2Model
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import static extension org.junit.Assert.*
import org.junit.Before
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.EList
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.Entity

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ModelTest_AssertNoErrors {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model model_Testmodel;
	
	Entity e;

	ResourceSet rs;
	private EList<ModelElement> elements;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		model_Testmodel = SIMPLE_MAIN_MODEL_M.load.parse(rs);
		elements = (model_Testmodel.modelLayer as Model).modelElements;
		//e = elements.filter(typeof(Entity)).head;
	}
	
	@Test
	def testAgainstErrors() {
		model_Testmodel.assertNoErrors;
	}
	
	@Test
	def numberOfEntitiesTest() {
		2.assertEquals(elements.filter(typeof(Entity)).size);
	}
	
	//EnumsTest fails - Parser does not count the enum elements
	@Test
	def numberOfEnumsTest() {
		1.assertEquals(elements.filter(typeof(Enum)).size);
	}
}