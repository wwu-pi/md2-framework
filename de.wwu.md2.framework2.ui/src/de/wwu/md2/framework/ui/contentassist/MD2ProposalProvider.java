package de.wwu.md2.framework.ui.contentassist;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.preference.JFacePreferences;
import org.eclipse.jface.viewers.StyledString;
import org.eclipse.xtext.Assignment;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.RuleCall;
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext;
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor;
import org.eclipse.xtext.util.Arrays;

import com.google.inject.Inject;

import de.wwu.md2.framework.mD2.MD2Model;
import de.wwu.md2.framework.util.MD2Util;

/**
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#contentAssist on how to customize content assistant
 */
public class MD2ProposalProvider extends AbstractMD2ProposalProvider {
	
	@Inject
	private MD2Util util;
	
	@Override
	public void completeMD2Model_Package(EObject model, Assignment assignment,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		super.completeMD2Model_Package(model, assignment, context, acceptor);
		
		String proposal = "package " + util.getPackageNameFromPath(model.eResource().getURI());
		StyledString display = new StyledString();
		display.append(proposal).setStyle(8, proposal.length() - 8, StyledString.QUALIFIER_STYLER);
		acceptor.accept(createCompletionProposal(proposal, display, null, context));
	}
	
	@Override
	public void completePackageDefinition_PkgName(EObject model, Assignment assignment,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		super.completePackageDefinition_PkgName(model, assignment, context, acceptor);
		
		String proposal = util.getPackageNameFromPath(model.eResource().getURI());
		acceptor.accept(createCompletionProposal(proposal, context));
	}
	
	@Override
	public void complete_STRING(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("\"\" [string]");
		displayString.setStyle(2, 9, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("\"\"", displayString, null, 1000, "", context));
	}
	
	@Override
	public void complete_INT(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("1 [integer]");
		displayString.setStyle(1, 10, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("1", displayString, null, 999, "", context));
	}
	
	@Override
	public void complete_FLOAT(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("1.0 [number]");
		displayString.setStyle(3, 9, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("1.0", displayString, null, 998, "", context));
	}
	
	@Override
	public void complete_Boolean(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayStringFalse = new StyledString("false [boolean]");
		displayStringFalse.setStyle(5, 10, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("false", displayStringFalse, null, 997, "", context));
		
		StyledString displayStringTrue = new StyledString("true [boolean]");
		displayStringTrue.setStyle(4, 10, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("true", displayStringTrue, null, 997, "", context));
	}
	
	@Override
	public void complete_DATE(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("2000-01-01 [date]");
		displayString.setStyle(10, 7, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("2000-01-01", displayString, null, 996, "", context));
	}
	
	@Override
	public void complete_TIME(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("00:00:00Z [time]");
		displayString.setStyle(10, 6, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("00:00:00Z", displayString, null, 995, "", context));
	}
	
	@Override
	public void complete_DATE_TIME(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		StyledString displayString = new StyledString("2000-01-01T00:00:00Z [datetime]");
		displayString.setStyle(20, 11, StyledString.createColorRegistryStyler(JFacePreferences.QUALIFIER_COLOR, null));
		acceptor.accept(createCompletionProposal("2000-01-01T00:00:00Z", displayString, null, 994, "", context));
	}
	
	@Override
	public void completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext, ICompletionProposalAcceptor acceptor) {
		
		if(keyword.getValue().equals("__Dummy")) {
			return;
		}
		
		// Prevent true and false from being suggested for boolean values. This is already handled by the explicite
		// method complete_Boolean(...)
		for (EObject eObject : contentAssistContext.getFirstSetGrammarElements()) {
			if(eObject instanceof RuleCall && ((RuleCall)eObject).getRule().getName().equals("Boolean")
				&& (keyword.getValue().equals("true") || keyword.getValue().equals("false"))) {
				
				return;
			}
		}
		
		// Guide content assist before the first element is set. In this state it is only implicitly known (defined by package name)
		// whether this is a controller, view or model and thus the default keyword content assist implementation has to be extended.
		if(!keyword.getValue().equals("package") && contentAssistContext.getCurrentModel() instanceof MD2Model) {
			MD2Model model = (MD2Model)contentAssistContext.getCurrentModel();
			String[] parts = model.getPackage().getPkgName().split("\\.");
			
			if( (Arrays.contains(parts, "controllers") && MD2Util.CONTROLLER_KEYWORDS.contains(keyword.getValue())) |
				(Arrays.contains(parts, "models") && MD2Util.MODEL_KEYWORDS.contains(keyword.getValue())) |
				(Arrays.contains(parts, "views") && MD2Util.VIEW_KEYWORDS.contains(keyword.getValue()))) {
				
				super.completeKeyword(keyword, contentAssistContext, acceptor);
			}
			
		} else {
			super.completeKeyword(keyword, contentAssistContext, acceptor);
		}
	}
}
