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
		/*
		 * general Formatting
		 */
 		//Package
		c.setLinewrap(2,2,2).after(packageDefinitionAccess.pkgNameAssignment_1)
		
		//TODO: How to handle comments 


		/*
		 * WORKFLOW Formatting
		 */
		





		/*
		 * VIEW Formatting
		 */
		// GridLayoutPane
		c.setLinewrap.before(gridLayoutPaneAccess.gridLayoutPaneKeyword_0)
		c.setLinewrap.after(gridLayoutPaneAccess.leftCurlyBracketKeyword_6)
		c.setIndentation(gridLayoutPaneAccess.leftCurlyBracketKeyword_6, gridLayoutPaneAccess.rightCurlyBracketKeyword_8)
		
		// FlowLayoutPane
		c.setLinewrap.before(flowLayoutPaneAccess.flowLayoutPaneKeyword_0)
		c.setLinewrap.after(flowLayoutPaneAccess.leftCurlyBracketKeyword_3)
		c.setIndentation(flowLayoutPaneAccess.leftCurlyBracketKeyword_3, gridLayoutPaneAccess.rightCurlyBracketKeyword_8)
		
		// AlternativesPane
		c.setLinewrap.before(alternativesPaneAccess.alternativesPaneKeyword_0)
		c.setLinewrap.after(alternativesPaneAccess.leftCurlyBracketKeyword_3)
		c.setIndentation(alternativesPaneAccess.leftCurlyBracketKeyword_3, gridLayoutPaneAccess.rightCurlyBracketKeyword_8)
		
		// TabbedAlternativesPane
		c.setLinewrap.before(tabbedAlternativesPaneAccess.tabbedPaneKeyword_0)
		c.setLinewrap.after(tabbedAlternativesPaneAccess.leftCurlyBracketKeyword_3)
		c.setIndentation(tabbedAlternativesPaneAccess.leftCurlyBracketKeyword_3, gridLayoutPaneAccess.rightCurlyBracketKeyword_8)
		
		// Button
		c.setLinewrap.before(buttonShorthandDefinitionAccess.buttonKeyword_0)
		
		
		
		
		
		/*
		 * CONTROLLER FORMATTING
		 */
		
		
		
		
		
		
		
		/*
		 * MODEL Formatting
		 */
		//Entity
		c.setLinewrap(2,2,3).before(entityAccess.entityKeyword_0)
		c.setLinewrap.before(entityAccess.leftCurlyBracketKeyword_2)
		c.setIndentation(entityAccess.leftCurlyBracketKeyword_2,entityAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap.before(entityAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap.before(entityAccess.attributesAssignment_3)
		c.setLinewrap.before(entityAccess.group)
		
		//Enums
		c.setLinewrap(2,2,3).before(enumAccess.enumKeyword_0)
		c.setLinewrap.after(enumAccess.leftCurlyBracketKeyword_2)
		c.setIndentation(enumAccess.leftCurlyBracketKeyword_2,entityAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap.before(enumAccess.enumBodyAssignment_3)
		c.setLinewrap.after(enumAccess.enumBodyAssignment_3)
		
		
	}
}
