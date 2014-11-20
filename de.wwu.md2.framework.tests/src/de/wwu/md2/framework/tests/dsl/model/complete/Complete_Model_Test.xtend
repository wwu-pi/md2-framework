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
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enumimport java.util.List
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.impl.ReferencedTypeImpl
import de.wwu.md2.framework.mD2.AttributeTypeimport de.wwu.md2.framework.mD2.StringType

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Complete_Model_Test {
	
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
	}
	
	@Test
	def testAgainstAnyErrors() {
		model_Testmodel.assertNoErrors;
	}
	
	@Test
	def numberOfEntitiesTest() {
		3.assertEquals(elements.filter(typeof(Entity)).size);
	}
	
	
	//TODO: EnumsTest fails - Parser does not count the enum elements
	@Test
	def numberOfEnumsTest() {
		1.assertEquals(enums.size);
	}
	
	@Test
	def BookCopyRelationshipTest() {
		1.assertEquals(book.attributes.filter[a| a.type.many && a.type instanceof ReferencedType].size);
	}
	
	@Test
	def PredefinedAttributeTypeTest() {
		assertTrue(book.attributes.filter[a| a.name.equals("isbn")].head.type instanceof StringType);
	}
	
	
	@Test
	def CopyPersonNavigationIntoTwoDirectionsTest() {
		
		//check whether there is an attribute of type Person called "borrowedBy" in the Copy entity
		val borrowedBy = copy.attributes.filter[a| a.type instanceof ReferencedType && a.name.equals("borrowedBy")].head;
		"Person".assertEquals((borrowedBy.type as ReferencedTypeImpl).element.name);
				
		//check whether there is a toMany attribute of type Copy called "loans" in the Person entity
		val loans = person.attributes.filter[a|a.type.many && a.type instanceof ReferencedType && a.name.equals("loans")].head;
		"Copy".assertEquals((loans.type as ReferencedTypeImpl).element.name);		
		
	}
	
	
	@Test
	def NumberOfAttributesTest() {
		4.assertEquals(copy.attributes.size);
	}
	
	
	@Test
	def ExtendedAttributeTest() {
		"PrivateAddress".assertEquals(person.attributes.filter[a| a.name.equals("address")].head.extendedName);
		"Address only as String!".assertEquals(person.attributes.filter[a| a.name.equals("address")].head.description);
	}
	
	
	@Test
	def void parseModelEntity() {
	    //Validate EntityA = Person
	    // TODO: PROBLEM - 2nd entity cannot be located / found
	    // val elem = (model.modelLayer as Model).modelElements
	    val entityA = (model_Testmodel.modelLayer as Model).modelElements.head
	    assertEquals(entityA.name, "Person")
	    assertEquals(entityA.eClass.name, "Entity")
	    val TEMP = entityA.eContents.head
	    //Validate EntityB = Details
	    val entityB = (model_Testmodel.modelLayer as Model).modelElements.last
	    entityB.name.assertEquals("Details")
	}
	
	@Test
	def parseModelEnum(){

		
		val tempEnum = (model_Testmodel.modelLayer as Model).modelElements.head
		tempEnum.name.assertEquals("Status")
		(tempEnum instanceof Enum).assertTrue
		val myEnum = tempEnum as Enum
		//val tempEnumElementfirst = myEnum.enumBody.elements.head
		//tempEnumElementfirst.assertEquals(statusElementFirst)
		//val tempEnumElementlast = myEnum.enumBody.elements.last
		//tempEnumElementlast.assertEquals(statusElementSecond)
	}
	
	
}