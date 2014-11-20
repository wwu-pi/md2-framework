package de.wwu.md2.framework.tests.dsl.model.complete

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.junit.Test
import static extension org.junit.Assert.*
import org.junit.Before
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.common.util.EList
import javax.inject.Inject

import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.MD2Model
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.ControllerElement



@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class CompleteTests {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model dataModel;
	Model modelLayer;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		dataModel = COMPLETE_MODEL_M.load.parse(rs);
		modelLayer =  (dataModel.modelLayer as Model)
		//elements = (mainModel.modelLayer as Controller).controllerElements;
		//main = elements.filter(typeof(Main)).head;
	}

	@Test
	def testPackage() {
		dataModel.assertNoErrors;
		val entity = modelLayer.modelElements.head;
	}
	
		@Test
	def void parseModelEntity() {
	    //Datamodel
	    val model = '''
	        package a.b.c.models
	        
	        entity Person {
	            name: String
	            details : Details
	        }
	        
	        entity Details {
	        	street : String
	        	city : String
	        }
	        '''.parse
	    //
	    //Validate EntityA = Person
	    // TODO: PROBLEM - 2nd entity cannot be located / found
	    // val elem = (model.modelLayer as Model).modelElements
	    val entityA = (model.modelLayer as Model).modelElements.head
	    assertEquals(entityA.name, "Person")
	    assertEquals(entityA.eClass.name, "Entity")
	    val TEMP = entityA.eContents.head
	    //Validate EntityB = Details
	    val entityB = (model.modelLayer as Model).modelElements.last
	    entityB.name.assertEquals("Details")
	}
	
	@Test
	def parseModelEnum(){
		val enumName = "Status"
		val statusElementFirst = "First"
		val statusElementSecond = "Second"
		
		val model = '''
		enum «enumName» {
			"«statusElementFirst»",
			"«statusElementSecond»"
		} 
		'''.parse
		
		val tempEnum = (model.modelLayer as Model).modelElements.head
		tempEnum.name.assertEquals(enumName)
		(tempEnum instanceof Enum).assertTrue
		val myEnum = tempEnum as Enum
		//val tempEnumElementfirst = myEnum.enumBody.elements.head
		//tempEnumElementfirst.assertEquals(statusElementFirst)
		//val tempEnumElementlast = myEnum.enumBody.elements.last
		//tempEnumElementlast.assertEquals(statusElementSecond)
	}
}
