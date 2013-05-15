package de.wwu.md2.framework.ui.contentassist;

import org.eclipse.emf.ecore.EObject;
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
	public void complete_FLOAT(EObject model, RuleCall ruleCall,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		
		super.complete_FLOAT(model, ruleCall, context, acceptor);
		acceptor.accept(createCompletionProposal("1.0", context));
	}

	@Override
	public void completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext, ICompletionProposalAcceptor acceptor) {
		
		if(keyword.getValue().equals("__Dummy")) {
			return;
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
