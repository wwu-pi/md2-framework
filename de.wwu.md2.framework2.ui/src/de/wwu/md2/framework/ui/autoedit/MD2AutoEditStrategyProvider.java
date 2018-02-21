package de.wwu.md2.framework.ui.autoedit;

import org.eclipse.jface.text.IDocument;
import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider;

/**
 * Implement auto-edit strategies for the editor.
 */
public class MD2AutoEditStrategyProvider extends DefaultAutoEditStrategyProvider {
	
	@Override
	protected void configure(IEditStrategyAcceptor acceptor) {
		
		// Handle formatting of the step definitions within a workflow block
		acceptor.accept(new WorkflowStepsAutoIndentStrategy(), IDocument.DEFAULT_CONTENT_TYPE);
		
		// Apply standard auto-edit strategies
		super.configure(acceptor);
	}
	
}
