package de.wwu.md2.framework.tests.dsl.model.validator

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
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImplimport de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.validation.ModelValidator

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class Validator_Model_Test {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model model_Testmodel;
	
	ResourceSet rs;
	
		//Loads the different Elements of the Model into the corresponding variables
	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		model_Testmodel = VALIDATOR_MODEL_M.load.parse(rs);

	}
	
	@Test
	def testDefaultValueForReference() {
		model_Testmodel.assertError(MD2Package::eINSTANCE.attrEnumDefault,ModelValidator::DEFAULTREFERENCEVALUE)
	}
	
}