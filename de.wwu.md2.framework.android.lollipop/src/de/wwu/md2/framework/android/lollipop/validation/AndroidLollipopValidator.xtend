package de.wwu.md2.framework.android.lollipop.validation

import de.wwu.md2.framework.validation.AbstractMD2JavaValidator
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.MD2Model

class AndroidLollipopValidator extends AbstractGeneratorSupportValidator{

	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
//	@Check
//	def checkUsedKeywords(MD2Model model){
//		model.
//	}
	
	@Check
    def checkAttributeTypeParam(AttributeTypeParam attributeTypeParam) {
        var unsupportedParamTypes = Sets.newHashSet(
            MD2Package.eINSTANCE.attrDateMax,
            MD2Package.eINSTANCE.attrDateMin,
            MD2Package.eINSTANCE.attrTimeMax,
            MD2Package.eINSTANCE.attrTimeMin,
            MD2Package.eINSTANCE.attrDateTimeMax,
            MD2Package.eINSTANCE.attrDateTimeMin
        );
        
        if (unsupportedParamTypes.contains(attributeTypeParam.eClass)) {
            warning("Unsupported by Android generator: " + attributeTypeParam.eClass.name + ". Using this parameter will have no effect.",
                MD2Package.eINSTANCE.attributeTypeParam.EIDAttribute, -1, UNSUPPORTEDPARAMTYPE
            );
        }
    }
	
}