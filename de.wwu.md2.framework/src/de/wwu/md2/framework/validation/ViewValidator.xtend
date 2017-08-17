package de.wwu.md2.framework.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.ActionDrawer

/**
 * Valaidators for all view elements of MD2.
 */
class ViewValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    
    /////////////////////////////////////////////////////////
	/// Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Ensures no ViewElements are used inside of a ListView
	 */
	@Check
	def checkListViews(ContainerElement ce){
		if (ce instanceof ListView){
			if (ce.elements.size > 0){
				for(e : ce.elements){
					if (!(e instanceof ActionDrawer)){
						acceptError("ViewElements inside a ListView are not allowed - ListView uses a dedicated activity to display a list without additional content",
						ce, null, -1, null);
					}
				}
			}
		}
	}

	    
}
