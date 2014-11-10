package de.wwu.md2.framework.tests.dsl

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import de.wwu.md2.framework.mD2.MD2Model
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import static extension org.junit.Assert.*

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class DSLTests {
	
	@Inject extension ParseHelper<MD2Model>	
	@Inject extension ValidationTestHelper
	
	@Test
	def myTest(){
		"".assertEquals("");
		val model='''
		this is my model
		'''.parse;
		model.assertNoErrors;
	}
}