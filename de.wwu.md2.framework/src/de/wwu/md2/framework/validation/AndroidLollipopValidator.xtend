package de.wwu.md2.framework.validation

import de.wwu.md2.framework.validation.AbstractMD2JavaValidator
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.MD2Model
import de.wwu.md2.framework.mD2.AttributeTypeParam
import com.google.common.collect.Sets
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement

class AndroidLollipopValidator extends AbstractGeneratorSupportValidator{


	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String NOTSUPPORTEDBYANDROIDGENERATOR = "Keyword not supported by Android Lollipop Generator: "
    public static final String USAGEOFKEYWORD = ". Using this keyword will have no effect."
    public static final String UNSUPPORTEDKEYWORD = "unsupportedKeywordByAndroidLollipopGenerator"
    
    // Model
//	@Check
//    def checkAttributeTypeParam(AttributeTypeParam attributeTypeParam) {
//        var supportedParamTypes = Sets.newHashSet(
//            
//        );
//        
//        if (!supportedParamTypes.contains(attributeTypeParam.eClass)) {
//            warning(NOTSUPPORTEDBYANDROIDGENERATOR + attributeTypeParam.eClass.name + USAGEOFKEYWORD,
//                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
//            );
//        }
//    }
//    
    // View
    @Check
    def checkContainerElements(ContainerElement containerElement) {
        var supportedParamTypes = Sets.newHashSet(
            MD2Package.eINSTANCE.gridLayoutPane
//            MD2Package.eINSTANCE.flowLayoutPane,
//            MD2Package.eINSTANCE.alternativesPane,
//            MD2Package.eINSTANCE.tabbedAlternativesPane
        );
        
        var strucFeatures = MD2Package.eINSTANCE.containerElement.EAllStructuralFeatures
        
        if (!supportedParamTypes.contains(containerElement.eClass)) {
        	warning(NOTSUPPORTEDBYANDROIDGENERATOR + containerElement.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.containerElement.EIDAttribute, -1, "something"
        	
//            warning(NOTSUPPORTEDBYANDROIDGENERATOR + containerElement.eClass.name + USAGEOFKEYWORD,
//                DomainmodelPackage$Literals::TYPE__NAME, -1, UNSUPPORTEDKEYWORD
            )
        }
    }
    
    @Check
    def checkContentElements(ContentElement contentElement) {
        var supportedParamTypes = Sets.newHashSet(
            MD2Package.eINSTANCE.spacer
        );
        
        if (!supportedParamTypes.contains(contentElement.eClass)) {
            warning(NOTSUPPORTEDBYANDROIDGENERATOR + contentElement.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    // Controller
    @Check
    def checkValidators(StandardValidator validator) {
        var supportedValidator = Sets.newHashSet(
            MD2Package.eINSTANCE.standardRegExValidator
        );
        
        if (supportedValidator.contains(validator.eClass)) {
            warning("Unsupported by Android generator: " + validator.eClass.name + ". Using this parameter will have no effect.",
                MD2Package.eINSTANCE.standardValidator.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
	
}