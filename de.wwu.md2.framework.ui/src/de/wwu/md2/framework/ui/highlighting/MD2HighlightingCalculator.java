package de.wwu.md2.framework.ui.highlighting;

import java.util.Set;

import org.eclipse.emf.common.util.Enumerator;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.xtext.CrossReference;
import org.eclipse.xtext.EnumLiteralDeclaration;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightedPositionAcceptor;
import org.eclipse.xtext.ui.editor.syntaxcoloring.ISemanticHighlightingCalculator;

import com.google.common.collect.Sets;

import de.wwu.md2.framework.mD2.AllowedOperation;
import de.wwu.md2.framework.mD2.ConditionalEventRef;
import de.wwu.md2.framework.mD2.ContentProvider;
import de.wwu.md2.framework.mD2.ContentProviderEventType;
import de.wwu.md2.framework.mD2.ElementEventType;
import de.wwu.md2.framework.mD2.FilterType;
import de.wwu.md2.framework.mD2.GlobalEventType;
import de.wwu.md2.framework.mD2.HexColorDef;
import de.wwu.md2.framework.mD2.LocationField;
import de.wwu.md2.framework.mD2.NamedColor;
import de.wwu.md2.framework.mD2.TextInput;
import de.wwu.md2.framework.mD2.TextInputType;

public class MD2HighlightingCalculator implements ISemanticHighlightingCalculator {
	
	@Override
	public void provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor) {
		
		if (resource == null || resource.getParseResult() == null) {
			return;
		}
		
		INode root = resource.getParseResult().getRootNode();
		for (INode node : root.getAsTreeIterable()) {
			
			// check for onConditionalEvent => if no event, check for cross reference
			if (node.getSemanticElement() != null && node.getSemanticElement() instanceof ConditionalEventRef) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.EVENT);
			} else if (node.getGrammarElement() instanceof CrossReference) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.CROSS_REF);
			}
			
			
			// predefined events
			if (node.getGrammarElement() instanceof EnumLiteralDeclaration) {
				Enumerator inst = ((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance();
				if (inst instanceof ElementEventType || inst instanceof GlobalEventType || inst instanceof ContentProviderEventType) {
					acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.EVENT);
				}
			}
			
			
			// if some name attribute equals a keyword, remove the keyword style
			if (node.getSemanticElement() != null) {
				for (EAttribute attribute : node.getSemanticElement().eClass().getEAllAttributes()) {
					if (attribute.getName().equals("name")
							&& node.getSemanticElement().eGet(attribute) != null
							&& node.getText().equals(node.getSemanticElement().eGet(attribute).toString())) {

						acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.DEFAULT_ID);
						break;
					}
				}
			}
			
			
			// handle color definitions
			if (node.getSemanticElement() != null && node.getSemanticElement() instanceof HexColorDef) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.NUMBER_ID);
			} else if (node.getGrammarElement() instanceof EnumLiteralDeclaration) {
				Enumerator inst = ((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance();
				if (inst instanceof NamedColor) {
					acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
				}
			}
			
			
			// if a keyword represents a parameter value, introduce own keyword style
			final Set<String> parameterKeywords = Sets.newHashSet("bold", "italic", "normal");
			if (node.getGrammarElement() instanceof Keyword
					&& parameterKeywords.contains(((Keyword) node.getGrammarElement()).getValue())) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
			}
			
			final Set<String> contentProviderContextParameterKeywords =
					Sets.newHashSet("true", "false", "default", "local");
			if(node.getGrammarElement() != null && node.getGrammarElement() instanceof Keyword
					&& contentProviderContextParameterKeywords.contains(((Keyword) node.getGrammarElement()).getValue())
					&& node.getSemanticElement() != null && node.getSemanticElement() instanceof ContentProvider) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
			} else if(node.getGrammarElement() != null && node.getGrammarElement() instanceof EnumLiteralDeclaration
					&& (((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance() instanceof AllowedOperation
						|| ((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance() instanceof FilterType)
					&& node.getSemanticElement() != null && node.getSemanticElement() instanceof ContentProvider) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
			} else if(node.getGrammarElement() != null && node.getGrammarElement() instanceof EnumLiteralDeclaration
					&& ((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance() instanceof TextInputType
					&& node.getSemanticElement() != null && node.getSemanticElement() instanceof TextInput) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
			} else if(node.getGrammarElement() != null && node.getGrammarElement() instanceof EnumLiteralDeclaration
					&& ((EnumLiteralDeclaration)node.getGrammarElement()).getEnumLiteral().getInstance() instanceof LocationField) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.PARAMETER_VALUE);
			}
			
			// fake cross-reference style for 'location' keyword that represents a content provider
			if(node.getGrammarElement() != null && node.getGrammarElement() instanceof Keyword
					&& ((Keyword) node.getGrammarElement()).getValue().equals("location")) {
				acceptor.addPosition(node.getOffset(), node.getLength(), MD2HighlightingConfiguration.CROSS_REF);
			}
		}
	}
}
