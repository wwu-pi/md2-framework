package de.wwu.md2.framework.tests.dsl.controller.fileUpload

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
class ValidatorTests {
    @Inject extension ParseHelper<MD2Model>
    @Inject extension ValidationTestHelper
    ResourceSet rs;
    
    @Before
    def void setUp() {
        rs = new ResourceSetImpl();
        FILE_UPLOAD_MODEL.load.parse(rs);
        FILE_UPLOAD_VIEW.load.parse(rs);
        FILE_UPLOAD_WORKFLOW.load.parse(rs);
    }
    
    @Test
    def testUploadConnection(){
        val controllerModel = FILE_UPLOAD_CONTROLLER_UPLOADCONNECTION.load.parse(rs);
        controllerModel.assertError(MD2Package::eINSTANCE.main, ControllerValidator::IMAGEUPLOAD);
    }
    
    @Test
    def testStoragePath(){
        val controllerModel = FILE_UPLOAD_CONTROLLER_STORAGEPATH.load.parse(rs);
        controllerModel.assertError(MD2Package::eINSTANCE.main, ControllerValidator::UPLOAD_SPECIFYPATH);
    }
    
    @Test
    def testMappings(){
        val controllerModel = FILE_UPLOAD_CONTROLLER_MAPPING.load.parse(rs);
        controllerModel.assertError(MD2Package::eINSTANCE.mappingTask, ControllerValidator::FILEUPLOADMAPPING);
        controllerModel.assertError(MD2Package::eINSTANCE.mappingTask, ControllerValidator::UPLOADEDIMAGEOUTPUTMAPPING);
    }
}
