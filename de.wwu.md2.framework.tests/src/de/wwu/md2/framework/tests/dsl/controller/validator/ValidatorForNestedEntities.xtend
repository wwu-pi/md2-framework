package de.wwu.md2.framework.tests.dsl.controller.validator

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import de.wwu.md2.framework.mD2.MD2Model
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.Before
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*

import org.junit.Test
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import de.wwu.md2.framework.validation.ControllerValidator
import de.wwu.md2.framework.mD2.MD2Package

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))
class ValidatorForNestedEntities {
	
	@Inject extension ParseHelper<MD2Model>
	@Inject extension ValidationTestHelper
	MD2Model nestedEntityValidationCModel;
	MD2Model nestedEntityValidationMModel;
	MD2Model nestedEntityValidationVModel;
	ResourceSet rs;

	@Before
	def void setUp() {
		rs = new ResourceSetImpl();
		nestedEntityValidationCModel = NESTED_ENTITY_VAL_C.load.parse(rs);
		nestedEntityValidationMModel = NESTED_ENTITY_VAL_M.load.parse(rs);
		nestedEntityValidationVModel = NESTED_ENTITY_VAL_V.load.parse(rs);
	}
	
	@Test
	def checkNestedEntityValidatorSavingTest(){
	    nestedEntityValidationCModel.assertWarning(MD2Package::eINSTANCE.contentProviderOperationAction, ControllerValidator::SAVINGCHECKOFNESTEDENTITY);
	}
	
	@Test
	def checkNestedEntityValidatorContentProviderTest(){
	    nestedEntityValidationCModel.assertWarning(MD2Package::eINSTANCE.contentProvider, ControllerValidator::NESTEDENTITYWITHOUTCONTENTPROVIDER);
	}
}