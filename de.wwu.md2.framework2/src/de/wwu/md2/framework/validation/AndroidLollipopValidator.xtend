package de.wwu.md2.framework.validation

import com.google.common.collect.Sets
import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.StandardValidator
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

// TODO: implement further validators to check supported types

class AndroidLollipopValidator extends AbstractMD2JavaValidator{

	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String NOTSUPPORTEDBYANDROIDGENERATOR = "Keyword not supported by Android Lollipop Generator: "
    public static final String USAGEOFKEYWORD = ". Using this keyword will have no effect."
    public static final String UNSUPPORTEDKEYWORD = "unsupportedKeywordByAndroidLollipopGenerator"
    
    // Model
	@Check
    def checkAttributeType(AttributeType attributeType) {
        var supportedParamTypes = Sets.newHashSet(
            MD2Package.eINSTANCE.stringType
            
        );
        
        if (!supportedParamTypes.contains(attributeType.eClass)) {
            warning(NOTSUPPORTEDBYANDROIDGENERATOR + attributeType.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    @Check
    def checkAttributeTypeMany(AttributeType attributeType) {        
        if (attributeType.many) {
            warning(NOTSUPPORTEDBYANDROIDGENERATOR + attributeType.eClass.name + USAGEOFKEYWORD,
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    // View
    @Check
    def checkContainerElements(ContainerElement containerElement) {
        var supportedContainerElements = Sets.newHashSet(
            MD2Package.eINSTANCE.gridLayoutPane,
            MD2Package.eINSTANCE.flowLayoutPane
        );
        
        if (!supportedContainerElements.contains(containerElement.eClass)) {
        	
			val node = NodeModelUtils.findActualNodeFor(containerElement)
			for (n : node.asTreeIterable) {
				val ge = n.grammarElement

				if (ge instanceof Keyword) {
					messageAcceptor.acceptWarning(
						NOTSUPPORTEDBYANDROIDGENERATOR + containerElement.eClass.name + USAGEOFKEYWORD,
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
            MD2Package.eINSTANCE.button,
            MD2Package.eINSTANCE.textInput,
            MD2Package.eINSTANCE.label
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
            // ...
        );
        
        if (supportedValidator.contains(validator.eClass)) {
            warning("Unsupported by Android generator: " + validator.eClass.name + ". Using this parameter will have no effect.",
                MD2Package.eINSTANCE.standardValidator.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    @Check
    def checkSimpleActions(SimpleAction simpleAction) {
        var supportedSimpleActions = Sets.newHashSet(
            MD2Package.eINSTANCE.gotoViewAction,
            MD2Package.eINSTANCE.displayMessageAction,
            MD2Package.eINSTANCE.contentProviderOperationAction,
            MD2Package.eINSTANCE.contentProviderResetAction
        );
        
        if (!supportedSimpleActions.contains(simpleAction.eClass)) {
            warning("Unsupported by Android generator: " + simpleAction.eClass.name + ". Using this keyword will have no effect.",
                MD2Package.eINSTANCE.standardValidator.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }
    
    @Check
    def checkCustomCodeFragment(CustomCodeFragment customCodeFragment) {
        var supportedCustomCodeFragments = Sets.newHashSet(
        	MD2Package.eINSTANCE.eventBindingTask,
            MD2Package.eINSTANCE.mappingTask,
            MD2Package.eINSTANCE.attributeSetTask,
            MD2Package.eINSTANCE.callTask,
            MD2Package.eINSTANCE.conditionalCodeFragment,
            MD2Package.eINSTANCE.abstractViewGUIElementRef,
            MD2Package.eINSTANCE.contentProviderPath,
            MD2Package.eINSTANCE.contentProviderReference
        );
        
        if (!supportedCustomCodeFragments.contains(customCodeFragment.eClass)) {
            warning("Unsupported by Android generator: " + customCodeFragment.eClass.name + ". Using this keyword will have no effect.",
                MD2Package.eINSTANCE.standardValidator.EIDAttribute, -1, UNSUPPORTEDKEYWORD
            );
        }
    }

}