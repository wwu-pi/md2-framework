package de.wwu.md2.framework.tests

import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension junit.framework.Assert.*
import javax.inject.Inject
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.Model


@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class ModelTests {
	
	@Inject extension ParseHelper<MD2Model> parser
	
	
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
		val tempEnumElementfirst = myEnum.enumBody.elements.head
		tempEnumElementfirst.assertEquals(statusElementFirst)
		val tempEnumElementlast = myEnum.enumBody.elements.last
		tempEnumElementlast.assertEquals(statusElementSecond)
	}
	
	
	
}
