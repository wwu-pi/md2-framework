package de.wwu.md2.framework.tests.dsl.controller.main

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import de.wwu.md2.framework.mD2.MD2Model
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*
import org.junit.Before
import org.eclipse.xtext.junit4.validation.ValidationTestHelper

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class MainTests {

	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model mainModel;

	@Before
	def void setUp() {
		mainModel = SIMPLE_MAIN_MODEL_C.load.parse();
	}

	@Test
	def testModel() {
		mainModel.assertNoErrors;
	}
}
