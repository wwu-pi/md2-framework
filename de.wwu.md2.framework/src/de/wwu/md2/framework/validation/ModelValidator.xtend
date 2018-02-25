package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AttrEnumDefault
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedType
import org.eclipse.xtext.validation.Check

/**
 * Validators for all model elements of MD2.
 */
class ModelValidator extends AbstractMD2Validator {
    
    @Inject
    private ValidatorHelpers helper;
    
    public static final String DEFAULTREFERENCEVALUE = "defaultReferenceValue"
    public static final String ENTITYENUMUPPERCASE = "entityEnumUppercase"
    public static final String ENTITYWITHOUTUNDERSCORE = "entityWithoutUnderscore"
    public static final String ENTITYWITHRESERVEDNAME = "entityWithReservedName"
    public static final String ATTRIBUTELOWERCASE = "attributeLowercase"
    public static final String REPEATEDPARAMS = "repeatedParams"
    public static final String UNSUPPORTEDPARAMTYPE = "unsupportedParamType"
    
    /////////////////////////////////////////////////////////
	/// Validators
	/////////////////////////////////////////////////////////
	/**
	 * Ensures that no default values are assigned to entities.
	 */
	@Check
	def checkParameterBelongsToReferencedType(ReferencedType type) {
		if (type.element instanceof Entity && !type.params.filter(AttrEnumDefault).empty){
			error("Cannot assign a default value to an entity.",
				MD2Package.eINSTANCE.referencedType_Element,
				DEFAULTREFERENCEVALUE);
		}
	}
	
	/**
     * Enforce conventions:
     * Warn the user if the defined entity or enum does not start with an upper case letter
     * 
     * @param modelElement
     */
    @Check
    def checkEntityStartsWithCapital(ModelElement modelElement) {
        if(!Character.isUpperCase(modelElement.name.charAt(0))) {
            warning("Entity and Enum identifiers should start with an upper case letter", 
            	MD2Package.eINSTANCE.modelElement_Name,
				ENTITYENUMUPPERCASE
            );
        }
    }
    
    /**
     * Prevent from using an underscore "_" in the beginning of an entity name
     */
     @Check
     def checkEntityDoesntStartWithUnderscore(ModelElement modelElement){
     	if(modelElement.name.charAt(0).equals(new Character ('_'))){
     		error("Entity and Enum identifiers shouldn't start with an underscore.",
     			MD2Package.eINSTANCE.modelElement_Name,
     			ENTITYWITHOUTUNDERSCORE
     		);
     	}
     }
     
     /**
     * Prevent from using the following preset identifiers as entity / enum names:
     * - WorkflowState
     * - EventHandler
     * - VersionNegotiation
     * - FileUpload,
     * since these names will conflict during generation of entities and webservices, e.g. on the backend.
     */
     @Check
     def checkEntityNameDoesntEqualPresetIdentifiers(ModelElement modelElement){
     	// Add new preset identifiers to the List, if they should also be excluded within the entity / enum names
     	var presetIdentifiers = newHashSet("WorkflowState",
     										"EventHandler",
     										"VersionNegotiation",
     										"FileUpload")
     	
		if(presetIdentifiers.contains(modelElement.name)){
 			error(presetIdentifiers+" shouldn't be used as an entity / enum name, since it is a preset identifier.", 
 				MD2Package.eINSTANCE.modelElement_Name, 
 				ENTITYWITHRESERVEDNAME);
 		}
     }
	
	/**
     * Enforce conventions:
     * Warn the user if the attribute name of an entity does not start with a lower case letter
     * 
     * @param feature
     */
    @Check
    def checkAttributeStartsWithCapital(Attribute attribute) {        
        if(!Character.isLowerCase(attribute.name.charAt(0))) {
            warning("Attribute should start with a lower case letter", 
            	MD2Package.eINSTANCE.attribute_Name, 
				ATTRIBUTELOWERCASE);
        }
    }
    
    /**
     * Prevent from defining the same parameter multiple times for the entity attribute constraint
     * 
     * @param attribute
     */
    @Check
    def checkRepeatedParams(AttributeType attributeType) {
        helper.repeatedParamsError(attributeType, null, this,
                "AttrIsOptional", "optional",
                "AttrIdentifier", "identifier",             
                "AttrIntMax", "max", "AttrIntMin", "min",
                "AttrFloatMax", "max", "AttrFloatMin", "min",
                "AttrStringMax", "maxLength", "AttrStringMin", "minLength",
                "AttrDateMax", "max", "AttrDateMin", "min",
                "AttrTimeMax", "max", "AttrTimeMin", "min",
                "AttrDateTimeMax", "max", "AttrDateTimeMin", "min");
    }
}
