package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AttrEnumDefault
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ReferencedType
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

/**
 * Valaidators for all model elements of MD2.
 */
class ModelValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String DEFAULTREFERENCEVALUE = "defaultReferenceValue"
    
    /////////////////////////////////////////////////////////
	/// Validators
	/////////////////////////////////////////////////////////
	
	
	/**
	 * Ensures that no default values are assigned to entities.
	 */
	@Check
	def checkParameterBelongsToReferencedType(ReferencedType type) {
		
		if (type.element instanceof Entity) {
			val enumDefault = type.params.filter(AttrEnumDefault).head
			if (enumDefault != null) {
				val error = '''Cannot assign a default value to an entity.'''
				acceptError(error, enumDefault, null, -1, DEFAULTREFERENCEVALUE);
			}
		}
	}
	
	
}
