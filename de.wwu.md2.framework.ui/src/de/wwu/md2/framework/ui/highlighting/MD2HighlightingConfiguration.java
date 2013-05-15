package de.wwu.md2.framework.ui.highlighting;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor;
import org.eclipse.xtext.ui.editor.utils.TextStyle;

public class MD2HighlightingConfiguration extends DefaultHighlightingConfiguration {
	
	public final static String CROSS_REF = "CrossReference";
	public final static String SIMPLE_ACTION = "SimpleAction";
	public final static String EVENT = "Event";
	public final static String PARAMETER_VALUE = "ParameterValue";
	
	@Override
	public void configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor);
		
		acceptor.acceptDefaultHighlighting(CROSS_REF, "Cross Reference", crossReferenceTextStyle());
		acceptor.acceptDefaultHighlighting(SIMPLE_ACTION, "Simple Action", redTextStyle());
		acceptor.acceptDefaultHighlighting(EVENT, "Event", redTextStyle());
		acceptor.acceptDefaultHighlighting(PARAMETER_VALUE, "Parameter Value", parameterValueTextStyle());
	}
	
	public TextStyle crossReferenceTextStyle() {
		TextStyle textStyle = new TextStyle();
		textStyle.setStyle(SWT.ITALIC);
		textStyle.setColor(new RGB(150, 55, 0));
		return textStyle;
	}
	
	public TextStyle redTextStyle() {
		TextStyle textStyle = new TextStyle();
		textStyle.setColor(new RGB(210, 0, 0));
		return textStyle;
	}
	
	public TextStyle parameterValueTextStyle() {
		TextStyle textStyle = defaultTextStyle().copy();
		textStyle.setColor(new RGB(150, 75, 110));
		textStyle.setStyle(SWT.NORMAL);
		return textStyle;
	}
}
