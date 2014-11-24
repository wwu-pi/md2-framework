package de.wwu.md2.framework.formatting;

import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter;
import org.eclipse.xtext.formatting.impl.FormattingConfig;

import de.wwu.md2.framework.services.MD2GrammarAccess;import com.google.inject.Inject

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
public class MD2Formatter extends AbstractDeclarativeFormatter {
	
	@Inject extension MD2GrammarAccess
	
	/**
	 * The formatter has to implement the method configureFormatting(...)
	 * which declaratively sets up a FormattingConfig. 
	 */
	override configureFormatting(FormattingConfig c) {
				
		c.setLinewrap.before(gridLayoutPaneAccess.gridLayoutPaneKeyword_0)
		
	}
}
