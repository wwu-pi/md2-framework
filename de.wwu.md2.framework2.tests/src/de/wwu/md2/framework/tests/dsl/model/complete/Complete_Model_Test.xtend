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
import de.wwu.md2.framework.mD2.StringType

/*
 * Set of Tests for the DSLs Model.
 * What is covered by these tests? Overview:
 * 
 * setUp - Load Model
 * 
 * testAgainstAnyErrors - general model check
 * numberOfEntitiesTest - right number of entities?
 * numberOfEnumsTest - right number of enums?
 * BookCopyRelationshipTest - relationship of book and copy?
 * PredefinedAttributeTypeTest - checks one attribute of entity 
 * CopyPersonNavigationIntoTwoDirections - bidirectional references (incl. toMany Relation)
 * NumberOfAttributesTest - right number of attributes?
 * Extended AttributeTest - extended attributes test
 * parseModelEntityTest - all entities parsed?
 * parseModelEnumTest - all enums parsed?
 */
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

	//Loads the different Elements of the Model into the corresponding variables
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		model_Testmodel = COMPLETE_MODEL_M.load.parse(rs);
		elements = (model_Testmodel.modelLayer as Model).modelElements;
		entities = elements.filter(typeof(Entity)).toList;
		enums = elements.filter(typeof(Enum)).toList;
		book = entities.get(0);
		copy = entities.get(1);	
		person = entities.get(2);
	}
	
	// General Model check
	@Test
	def testAgainstAnyErrors() {
		model_Testmodel.assertNoErrors;
	}
	
	// Tests, if the amount of entities after parsing, equals the amount of Entities in the model.
	@Test
	def numberOfEntitiesTest() {
		3.assertEquals(elements.filter(typeof(Entity)).size);
	}
	
	// Tests, if the amount of enums after parsing, equals the amount of enums in the model.
	@Test
	def numberOfEnumsTest() {
		1.assertEquals(enums.size);
	}
	
	// Checks the relationship of book and copy
	@Test
	def BookCopyRelationshipTest() {
	    var referencedObjects = book.attributes.filter[a | a.type.many && a.type instanceof ReferencedType]
	    // Assert only one referencing attribute
		1.assertEquals(referencedObjects.size);
		// Assert array is of type Copy
		copy.assertEquals((referencedObjects.head.type as ReferencedType).element)
	}
	
	// Checks an exemplary attribute of the entity book
	@Test
	def PredefinedAttributeTypeTest() {
		assertTrue(book.attributes.filter[a| a.name.equals("isbn")].head.type instanceof StringType);
	}
	
	// Tests, if bidirectional reference is parsed correctly (incl. a toMany relation)
	@Test
	def CopyPersonNavigationIntoTwoDirectionsTest() {
	    
		// Check whether there is an attribute of type Person called "borrowedBy" in the Copy entity
		val borrowedBy = copy.attributes.filter[a | a.type instanceof ReferencedType && a.name.equals("borrowedBy")].head;
		person.assertEquals((borrowedBy.type as ReferencedType).element);
				
		// Check whether there is a toMany attribute of type Copy called "loans" in the Person entity
		val loans = person.attributes.filter[a | a.type.many && a.type instanceof ReferencedType && a.name.equals("loans")].head;
		copy.assertEquals((loans.type as ReferencedType).element);		
	}
	
	
	// Tests, if the number of attributes in entity copy and book are correct
	@Test
	def NumberOfAttributesTest() {
		6.assertEquals(copy.attributes.size)
		4.assertEquals(book.attributes.size)
		4.assertEquals(person.attributes.size)
		// Lets check the check
		0.assertNotEquals(copy.attributes.size)
	}
	
	// Tests, if the extended attribute is parsed correctly
	@Test
	def ExtendedAttributeTest() {
	    val _address = person.attributes.filter[it.name.equals("address")].head
		"PrivateAddress".assertEquals(_address.extendedName);
		"Address only as String!".assertEquals(_address.description);
	}
	
	// Tests, if the models entities are all present after parsing
	@Test
	def void parseModelEntityTest() {
		"Copy".assertEquals(copy.name)
		"Book".assertEquals(book.name)
		"Person".assertEquals(person.name)
	    "Entity".assertEquals(copy.eClass.name)
	    "Entity".assertEquals(book.eClass.name)
	    "Entity".assertEquals(person.eClass.name)
	}
	
	// Tests, if the models enums are all present after parsing
	@Test
	def parseModelEnumTest(){
		val statusEnum = enums.get(0)
		"Status".assertEquals(statusEnum.name)
		"Enum".assertEquals(statusEnum.eClass.name)
	}
}
