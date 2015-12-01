
package de.wwu.md2.framework.ui.quickfix;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.ui.editor.model.edit.IModificationContext;
import org.eclipse.xtext.ui.editor.model.edit.ISemanticModification;
import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider;
import org.eclipse.xtext.ui.editor.quickfix.Fix;
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor;
import org.eclipse.xtext.validation.Issue;

import de.wwu.md2.framework.mD2.Entity;
import de.wwu.md2.framework.validation.ModelValidator;

public class MD2QuickfixProvider extends DefaultQuickfixProvider {

	@Fix(ModelValidator.ENTITYWITHOUTUNDERSCORE)
	public void deleteUnderscoreFromEntityname(final Issue issue, IssueResolutionAcceptor acceptor){
		acceptor.accept(issue, "Delete underscore", "Deletes the underscore from the entity/enum identifier.", "upcase.png", new ISemanticModification() {
			public void apply(EObject element, IModificationContext context) {
				Entity entity = ((Entity) element);
				entity.setName(entity.getName().substring(1));
			}
		});
	}
	
}
