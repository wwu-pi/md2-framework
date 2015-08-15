package de.wwu.md2.framework.validation

//import de.wwu.md2.framework.validation.AbstractMD2JavaValidator
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
//import de.wwu.md2.framework.mD2.MD2Model
//import de.wwu.md2.framework.mD2.AttributeTypeParam
import com.google.common.collect.Sets
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.Keyword
import de.wwu.md2.framework.mD2.AttributeType

//import de.wwu.md2.framework.services.MD2GrammarAccess

class IOSValidator extends AbstractGeneratorSupportValidator{

	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    //@Inject extension MD2GrammarAccess
    
    public static final String NOTSUPPORTEDBYIOSGENERATOR = "Keyword not supported by iOS Generator: "
    public static final String USAGEOFKEYWORD = ". Using this keyword will have no effect."
    public static final String UNSUPPORTEDKEYWORD = "unsupportedKeywordByIOSGenerator"
    
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
        var supportedContainerElements = Sets.newHashSet(
            MD2Package.eINSTANCE.gridLayoutPane,
            MD2Package.eINSTANCE.flowLayoutPane
//            MD2Package.eINSTANCE.alternativesPane,
//            MD2Package.eINSTANCE.tabbedAlternativesPane
        );
        
        if (!supportedContainerElements.contains(containerElement.eClass)) {
        	
			val node = NodeModelUtils.findActualNodeFor(containerElement)
			for (n : node.asTreeIterable) {
				val ge = n.grammarElement

				if (ge instanceof Keyword) {
					messageAcceptor.acceptWarning(
						de.wwu.md2.framework.validation.IOSValidator.NOTSUPPORTEDBYIOSGENERATOR + containerElement.eClass.name + USAGEOFKEYWORD,
						containerElement,
						n.offset,
						n.length,
						UNSUPPORTEDKEYWORD
					)
				}
			}            
        }
    }
    
    @Check
    def checkContentElements(ContentElement contentElement) {
        var supportedParamTypes = Sets.newHashSet(
//            MD2Package.eINSTANCE.spacer
        );
        
        if (!supportedParamTypes.contains(contentElement.eClass)) {
            warning(de.wwu.md2.framework.validation.IOSValidator.NOTSUPPORTEDBYIOSGENERATOR + contentElement.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    // Controller
    @Check
    def checkValidators(StandardValidator validator) {
        var supportedValidator = Sets.newHashSet(
//            MD2Package.eINSTANCE.standardRegExValidator
        );
        
        if (!supportedValidator.contains(validator.eClass)) {
            warning("Unsupported by Android generator: " + validator.eClass.name + ". Using this parameter will have no effect.",
                MD2Package.eINSTANCE.standardValidator.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    // Model
	@Check
    def checkAttributeTypes(AttributeType attributeType) {
        var supportedParamTypes = Sets.newHashSet(
            MD2Package.eINSTANCE.integerType
            , MD2Package.eINSTANCE.floatType
            , MD2Package.eINSTANCE.stringType
            , MD2Package.eINSTANCE.booleanType
            , MD2Package.eINSTANCE.dateType
            , MD2Package.eINSTANCE.timeType
            , MD2Package.eINSTANCE.dateTimeType
            , MD2Package.eINSTANCE.enumType
//            , MD2Package.eINSTANCE.fileType
        );
        
        if (!supportedParamTypes.contains(attributeType.eClass)) {
            warning(de.wwu.md2.framework.validation.IOSValidator.NOTSUPPORTEDBYIOSGENERATOR + attributeType.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
}