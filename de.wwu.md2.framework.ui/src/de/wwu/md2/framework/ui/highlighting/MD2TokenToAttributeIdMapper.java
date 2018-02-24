package de.wwu.md2.framework.ui.highlighting;

import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper;

public class MD2TokenToAttributeIdMapper extends DefaultAntlrTokenToAttributeIdMapper  {
	
	@Override
	protected String calculateId(String tokenName, int tokenType) {
		
		// add proper highlighting for the DATE, TIME and DATE_TIME terminal rules in the MD2 grammar
		
		if("RULE_DATE_FORMAT".equals(tokenName)) {
			return MD2HighlightingConfiguration.NUMBER_ID;
		}
		
		if("RULE_TIME_FORMAT".equals(tokenName)) {
			return MD2HighlightingConfiguration.NUMBER_ID;
		}
		
		if("RULE_DATE_TIME_FORMAT".equals(tokenName)) {
			return MD2HighlightingConfiguration.NUMBER_ID;
		}
		
		return super.calculateId(tokenName, tokenType);
	}
	
}
