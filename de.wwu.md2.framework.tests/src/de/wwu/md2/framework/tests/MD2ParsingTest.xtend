/*
 * generated by Xtext 2.13.0
 */
package de.wwu.md2.framework.tests

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(MD2InjectorProvider)
class MD2ParsingTest {
	@Inject
	ParseHelper<MD2Model> parseHelper
	
	@Test
	def void loadModel() {
		val result = parseHelper.parse('''
			Hello Xtext!
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
	}
}
