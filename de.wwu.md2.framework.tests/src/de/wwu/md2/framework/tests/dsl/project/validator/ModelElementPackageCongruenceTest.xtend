package de.wwu.md2.framework.tests.dsl.project.validator

import org.eclipse.xtext.junit4.InjectWith
import de.wwu.md2.framework.MD2InjectorProvider
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import de.wwu.md2.framework.mD2.MD2Model
import org.junit.Before
import static extension de.wwu.md2.framework.tests.utils.ModelProvider.*

import org.junit.Test
import org.eclipse.xtext.junit4.validation.ValidationTestHelper

import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.validation.ProjectValidator

@InjectWith(typeof(MD2InjectorProvider))
@RunWith(typeof(XtextRunner))

class ModelElementPackageCongruenceTest {
    @Inject extension ParseHelper<MD2Model>
    @Inject extension ValidationTestHelper
    
    MD2Model controllerModel
    MD2Model modelModel
    MD2Model viewModel
    MD2Model workflowModel
    MD2Model testModel

    @Before
    def void setUp() {
        controllerModel = PROJECT_VALIDATOR_MEC_CIW.load.parse
        modelModel = PROJECT_VALIDATOR_MEC_MIW.load.parse
        viewModel = PROJECT_VALIDATOR_MEC_VIM.load.parse
        workflowModel = PROJECT_VALIDATOR_MEC_WIM.load.parse
        testModel = PROJECT_VALIDATOR_MEC_CIC.load.parse
    }
    
    /**
     * Test whether the correct error is thrown when model elements are declared in the wrong file.
     */
    @Test
    def checkModelElementCompliesWithPackageTest() {
        controllerModel.assertError(MD2Package::eINSTANCE.MD2Model, ProjectValidator::MODELELEMENT_PACKAGE)
        modelModel.assertError(MD2Package::eINSTANCE.MD2Model, ProjectValidator::MODELELEMENT_PACKAGE)
        viewModel.assertError(MD2Package::eINSTANCE.MD2Model, ProjectValidator::MODELELEMENT_PACKAGE)
        workflowModel.assertError(MD2Package::eINSTANCE.MD2Model, ProjectValidator::MODELELEMENT_PACKAGE)
    }
    
    @Test
    def checkNoErrorForCorrectPackage(){
        testModel.assertNoError(ProjectValidator::MODELELEMENT_PACKAGE)
    }
}
