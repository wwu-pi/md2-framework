package de.wwu.md2.framework.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.builder.BuilderParticipant;
import org.eclipse.xtext.ui.editor.autoedit.AbstractEditStrategyProvider;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.ISemanticHighlightingCalculator;
import org.eclipse.xtext.ui.wizard.IProjectCreator;

import de.wwu.md2.framework.ui.autoedit.MD2AutoEditStrategyProvider;
import de.wwu.md2.framework.ui.generator.MD2BuilderParticipent;
import de.wwu.md2.framework.ui.highlighting.MD2HighlightingCalculator;
import de.wwu.md2.framework.ui.highlighting.MD2HighlightingConfiguration;
import de.wwu.md2.framework.ui.highlighting.MD2TokenToAttributeIdMapper;
import de.wwu.md2.framework.ui.wizard.MD2ExtendedProjectCreator;

/**
 * Use this class to register components to be used within the IDE.
 */
public class MD2UiModule extends de.wwu.md2.framework.ui.AbstractMD2UiModule {
	
	public MD2UiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}
	
	@Override
	public Class<? extends BuilderParticipant> bindIXtextBuilderParticipant() {
		return MD2BuilderParticipent.class;
	}

	@Override
	public Class<? extends AbstractEditStrategyProvider> bindAbstractEditStrategyProvider() {
		return MD2AutoEditStrategyProvider.class;
	}
	
	@Override
	public Class<? extends IProjectCreator> bindIProjectCreator() {
		return MD2ExtendedProjectCreator.class;
	}
	
	public Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration () {
		return MD2HighlightingConfiguration.class;
	}
	
	public Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator(){
		return MD2HighlightingCalculator.class;
	}
	
	public Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindTokenToAttributeIdMapper() {
		return MD2TokenToAttributeIdMapper.class;
	}
}
