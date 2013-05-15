package de.wwu.md2.framework.tests

import de.wwu.md2.framework.MD2InjectorProvider
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static junit.framework.Assert.*
import javax.inject.Inject
import de.wwu.md2.framework.mD2.Model


@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class ModelTests {
	
	@Inject ParseHelper<MD2Model> parser
	
	@Test
	def void parseModelEntity() {
	    val model = parser.parse(
	        "entity Person {
	            name: String
	        }")
	    
	    val entity = (model.modelLayer as Model).modelElements.head
	    assertEquals(entity.name, "Person")
	    assertEquals(entity.eClass.name, "Entity")
	}
}
