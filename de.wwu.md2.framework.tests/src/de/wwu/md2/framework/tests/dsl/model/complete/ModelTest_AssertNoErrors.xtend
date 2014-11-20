package de.wwu.md2.framework.tests.dsl.model.complete

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
import de.wwu.md2.framework.mD2.Entityimport java.util.List
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.impl.ReferencedTypeImpl

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ModelTest_AssertNoErrors {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model model_Testmodel;
	

	ResourceSet rs;
	private EList<ModelElement> elements;
	private List<Entity> entities;
	private List<Enum> enums;
 	private Entity book;
	private Entity copy;
	private Entity person;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		model_Testmodel = COMPLETE_MODEL_M.load.parse(rs);
		elements = (model_Testmodel.modelLayer as Model).modelElements;
		entities = elements.filter(typeof(Entity)).toList;
		enums = elements.filter(typeof(Enum)).toList;
		book = elements.filter(typeof(Entity)).head;
		copy = entities.get(1);	
		person = entities.get(2);
		
		System.out.println(copy.name + ", " + person.name);
	}
	
	@Test
	def testAgainstAnyErrors() {
		model_Testmodel.assertNoErrors;
	}
	
	@Test
	def numberOfEntitiesTest() {
		3.assertEquals(elements.filter(typeof(Entity)).size);
	}
	
	
	//EnumsTest fails - Parser does not count the enum elements
	@Test
	def numberOfEnumsTest() {
		1.assertEquals(enums.size);
	}
	
	@Test
	def BookCopyRelationshipTest() {
		1.assertEquals(book.attributes.filter[a| a.type.many && a.type instanceof ReferencedType].size);
	}
	
	@Test
	def CopyPersonNavigationIntoTwoDirectionsTest() {
		2.assertEquals(copy.attributes.filter[a| !(a.type instanceof ReferencedType)].size );
		assertTrue(copy.attributes.exists[a| a.type instanceof ReferencedType && a.name.equals("borrowedBy")]);
		
		val borrowedBy = copy.attributes.filter[a| a.type instanceof ReferencedType && a.name.equals("borrowedBy")].head;
		"Person".assertEquals((borrowedBy.type as ReferencedTypeImpl).element.name);
		
		"Copy".assertEquals((person.attributes.filter[a| a.type instanceof ReferencedType && a.name.equals("loans")].head.type as ReferencedTypeImpl).element.name);		
		
		assertTrue(person.attributes.exists[a| a.type.many && a.type instanceof ReferencedType && a.name.equals("loans")]);
		1.assertEquals(person.attributes.filter[a| a.type.many && a.type instanceof ReferencedType].size);
	}
	
}