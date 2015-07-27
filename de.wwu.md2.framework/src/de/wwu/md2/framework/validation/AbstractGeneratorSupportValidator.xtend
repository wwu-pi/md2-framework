package de.wwu.md2.framework.validation

import com.google.common.collect.Sets
import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AttrEnumDefault
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.AttributeTypeParam
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedType
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import java.util.Set

/**
 * Valaidators for all elements of MD2.
 */

abstract class AbstractGeneratorSupportValidator extends AbstractMD2JavaValidator {

	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    @Inject
    private ValidatorHelpers helper
    
    protected Set<String> supportedKeywords
    
}