package de.wwu.md2.framework.formatting;

import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter;
import org.eclipse.xtext.formatting.impl.FormattingConfig;

import de.wwu.md2.framework.services.MD2GrammarAccess;
import org.eclipse.xtext.Keyword

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
public class MD2Formatter extends AbstractDeclarativeFormatter {
	
	/**
	 * The formatter has to implement the method configureFormatting(...)
	 * which declaratively sets up a FormattingConfig. 
	 */
	override configureFormatting(FormattingConfig c) {
		val MD2GrammarAccess f = grammarAccess as MD2GrammarAccess
		
		/*
		 * general Formatting
		 */
		 
 		//Package
		c.setAutoLinewrap(120);
 		
		c.setLinewrap(2,2,2).after(f.packageDefinitionAccess.pkgNameAssignment_1)

		//Comments
		c.setLinewrap(0,1,2).around(f.SL_COMMENTRule)
		c.setLinewrap(2,2,3).around(f.ML_COMMENTRule)
		
		//Handling of curly-brackets
		for (Keyword k : f.findKeywords("{")) {
			c.setLinewrap(1,1,2).after(k);
			c.setIndentationIncrement.after(k)
		}
		for (Keyword k : f.findKeywords("}")) {
			c.setIndentationDecrement.before(k)
			c.setLinewrap(1,1,2).before(k);
			c.setLinewrap(1,1,3).after(k);
		}
		
		//Handling of dots for path-"navigation"
		for (Keyword k : f.findKeywords(".")) {
			c.setNoSpace.around(k);
		}
		
		//Path and reference definitions
		for (Keyword k : f.contentProviderPathAccess.findKeywords(":")) {
			c.setNoSpace.after(k);
		}
		for (Keyword k : f.locationProviderPathAccess.findKeywords(":")) {
			c.setNoSpace.after(k);
		}
		for (Keyword k : f.contentProviderReferenceAccess.findKeywords(":")) {
			c.setNoSpace.after(k);
		}
		for (Keyword k : f.locationProviderReferenceAccess.findKeywords(":")) {
			c.setNoSpace.after(k);
		}
		
		//Formatting of workflow:
		formattingWorkflow(c,f)

		//Formatting of view:
		formattingView(c,f)
		
		//Formatting of controller:
		formattingController(c,f)
		
		//Formatting of model:
		formattingModel(c,f)
	}
	
	
	/**
	 * MODEL formatting
	 * 
	 * @param FormattingConfig, MD2GrammarAccess
	 */
	def formattingModel(FormattingConfig c, MD2GrammarAccess f){
		//Entity
		c.setLinewrap(0,0,3).before(f.entityAccess.entityKeyword_0)
		c.setLinewrap.before(f.entityAccess.attributesAssignment_3)		
		
		//Enums
		c.setLinewrap(0,0,3).before(f.enumAccess.enumKeyword_0)
		for (Keyword k : f.enumBodyAccess.findKeywords(",")) {
			c.setNoSpace.before(k);
			c.setLinewrap.after(k);
		}
	}
	
	
	/**
	 * VIEW formatting
	 * 
	 * @param FormattingConfig, MD2GrammarAccess 
	 */
	def formattingView(FormattingConfig c, MD2GrammarAccess f){
		
		//GridLayoutPane
		c.setLinewrap.before(f.gridLayoutPaneAccess.gridLayoutPaneKeyword_0)

		//FlowLayoutPane
		c.setLinewrap.before(f.flowLayoutPaneAccess.flowLayoutPaneKeyword_0)
		
		//AlternativesPane
		c.setLinewrap.before(f.alternativesPaneAccess.alternativesPaneKeyword_0)

		//TabbedAlternativesPane
		c.setLinewrap.before(f.tabbedAlternativesPaneAccess.tabbedPaneKeyword_0)

		//Styles
		c.setLinewrap.before(f.styleBodyAccess.fontSizeKeyword_2_0_0)
		c.setLinewrap.before(f.styleBodyAccess.colorKeyword_2_1_0)
		c.setLinewrap.before(f.styleBodyAccess.textStyleKeyword_2_2_0)

		//Button
		c.setLinewrap.before(f.buttonShorthandDefinitionAccess.buttonKeyword_0)
		c.setLinewrap.before(f.buttonExtendedDefinitionAccess.buttonKeyword_0)
		
		//Attributes (a somewhat dirty way of handling the keywords [affects the whole model], but seems to work ;) )
		for (Keyword k : f.findKeywords("label")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("tooltip")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("type")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("disabled")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("default")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("width")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("style")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("text")) {
			c.setLinewrap.before(k);
		}
		for (Keyword k : f.findKeywords("places")) {
			c.setLinewrap.before(k);
		}
		c.setLinewrap.before(f.optionInputAccess.optionsKeyword_2_1_6_0)
		c.setLinewrap.before(f.entitySelectorAccess.textPropositionKeyword_3_4_0)
		
	}
	
	
	/**
	 * CONTROLLER formatting
	 * 
	 * @param FormattingConfig, MD2GrammarAccess 
	 */
	def formattingController(FormattingConfig c, MD2GrammarAccess f){
		
		//ContentProvider
		c.setLinewrap(1,1,2).before(f.contentProviderAccess.contentProviderKeyword_0)
		c.setLinewrap.before(f.contentProviderAccess.providerTypeKeyword_4_0_0)
		
		//Validator
		c.setLinewrap(1,1,2).before(f.validatorAccess.validatorKeyword_0)
		c.setLinewrap(1,1,2).before(f.remoteValidatorAccess.remoteValidatorKeyword_0)
		c.setLinewrap.before(f.remoteValidatorAccess.connectionKeyword_3_1_0)
		c.setLinewrap.before(f.remoteValidatorAccess.modelKeyword_3_2_0_0)
		c.setLinewrap.before(f.remoteValidatorAccess.attributesKeyword_3_2_1_0)
		
		//Main
		c.setLinewrap(1,1,2).before(f.mainAccess.mainKeyword_0)
		c.setLinewrap.before(f.mainAccess.appVersionKeyword_2_0_0)
		c.setLinewrap.before(f.mainAccess.modelVersionKeyword_2_1_0)
		c.setLinewrap.before(f.mainAccess.workflowManagerKeyword_2_2_0)
		c.setLinewrap.before(f.mainAccess.defaultConnectionKeyword_2_3_0)
		c.setLinewrap.before(f.mainAccess.fileUploadConnectionKeyword_2_4_0)
		
		//RemoteConnection
		c.setLinewrap(1,1,2).before(f.remoteConnectionAccess.remoteConnectionKeyword_0)
		c.setLinewrap.before(f.remoteConnectionAccess.uriKeyword_3_0_0)
		c.setLinewrap.before(f.remoteConnectionAccess.passwordKeyword_3_1_0)
		c.setLinewrap.before(f.remoteConnectionAccess.userKeyword_3_2_0)
		c.setLinewrap.before(f.remoteConnectionAccess.keyKeyword_3_3_0)
		
		//WorkflowElement
		c.setLinewrap(1,1,2).before(f.workflowElementAccess.workflowElementKeyword_0)
		c.setLinewrap.before(f.workflowElementAccess.defaultProcessChainKeyword_3_0)
		c.setLinewrap.before(f.workflowElementAccess.onInitKeyword_3_2)
		for (Keyword k : f.workflowElementAccess.findKeywords(",")) {
			c.setNoSpace.before(k);
			c.setLinewrap.after(k);
		}
		//InvokeDefinitions
		c.setLinewrap.before(f.invokeDefinitionAccess.invokableKeyword_1)
		
		//WebServiceCall
		c.setLinewrap(1,1,2).before(f.webServiceCallAccess.externalWebServiceKeyword_0)
		c.setLinewrap.before(f.webServiceCallAccess.urlKeyword_3_0_0)
		c.setLinewrap.before(f.webServiceCallAccess.methodKeyword_3_1_0)
		c.setLinewrap.before(f.webServiceCallAccess.queryparamsKeyword_3_2_0)
		c.setLinewrap.before(f.webServiceCallAccess.bodyparamsKeyword_3_3_0)
		c.setLinewrap.before(f.RESTParamAccess.keyAssignment_0)
		c.setIndentationIncrement.before(f.RESTParamAccess.keyAssignment_0)
		c.setIndentationDecrement.after(f.RESTParamAccess.keyAssignment_0)
		c.setLinewrap.before(f.webServiceCallAccess.rightParenthesisKeyword_3_2_3)
		c.setLinewrap.before(f.webServiceCallAccess.rightParenthesisKeyword_3_3_3)
		
		
		//Action
		c.setLinewrap.before(f.actionAccess.actionKeyword_0)
		
		//SimpleActions
		c.setLinewrap.before(f.simpleActionAccess.inputsKeyword_12_1_2)
		c.setLinewrap.before(f.simpleActionAccess.cityInputKeyword_12_1_4_0_0)
		c.setLinewrap.before(f.simpleActionAccess.streetInputKeyword_12_1_4_1_0)
		c.setLinewrap.before(f.simpleActionAccess.streetNumberInputKeyword_12_1_4_2_0)
		c.setLinewrap.before(f.simpleActionAccess.postalInputKeyword_12_1_4_3_0)
		c.setLinewrap.before(f.simpleActionAccess.countryInputKeyword_12_1_4_4_0)
		c.setLinewrap.before(f.simpleActionAccess.outputsKeyword_12_1_6)
		c.setLinewrap.before(f.simpleActionAccess.latitudeOutputKeyword_12_1_8_0_0)
		c.setLinewrap.before(f.simpleActionAccess.longitudeOutputKeyword_12_1_8_1_0)
		//Handling of the brackets connected to location 
		// (for changes: the numbers of the elements should always start with the 
		// same number as for the elements seen above e.g. "12_")
		//  Handling of "("
		c.setLinewrap.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_1)
		c.setIndentationIncrement.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_1)
		c.setLinewrap.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_3)
		c.setIndentationIncrement.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_3)
		c.setLinewrap.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_7)
		c.setIndentationIncrement.after(f.simpleActionAccess.leftParenthesisKeyword_12_1_7)
		//  Handling of ")"
		c.setLinewrap.around(f.simpleActionAccess.rightParenthesisKeyword_12_1_5)
		c.setIndentationDecrement.before(f.simpleActionAccess.rightParenthesisKeyword_12_1_5)
		c.setLinewrap.around(f.simpleActionAccess.rightParenthesisKeyword_12_1_9)
		c.setIndentationDecrement.before(f.simpleActionAccess.rightParenthesisKeyword_12_1_9)
		c.setLinewrap.around(f.simpleActionAccess.rightParenthesisKeyword_12_1_10)
		c.setIndentationDecrement.before(f.simpleActionAccess.rightParenthesisKeyword_12_1_10)
		
		//CustomCodeFragment Keywords
		c.setLinewrap.before(f.customCodeFragmentAccess.bindKeyword_0_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.unbindKeyword_1_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.callKeyword_2_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.mapKeyword_3_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.unmapKeyword_4_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.setKeyword_5_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.ifKeyword_6_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.elseifKeyword_6_1_2_0)
		c.setLinewrap.before(f.customCodeFragmentAccess.elseKeyword_6_1_3_0)
		
		//ProcessChainSteps
		for (Keyword k : f.processChainStepAccess.findKeywords(":")) {
			c.setNoSpace.before(k);
		}
		
	}
	
	
	/**
	 * WORKFLOW formatting
	 * 
	 * @param FormattingConfig, MD2GrammarAccess 
	 */
	def formattingWorkflow(FormattingConfig c, MD2GrammarAccess f){
		
		//WorkflowElementEntries
		c.setLinewrap.before(f.workflowElementEntryAccess.workflowElementKeyword_0)
		
		//Apps:
		c.setLinewrap.before(f.appAccess.appKeyword_0_0)
		c.setNoSpace.before(f.appAccess.commaKeyword_0_3_3_0)
		c.setLinewrap.after(f.appAccess.commaKeyword_0_3_3_0)
		c.setLinewrap.before(f.fireEventEntryAccess.firesKeyword_0)
		c.setIndentationIncrement.before(f.fireEventEntryAccess.firesKeyword_0)
		c.setIndentationDecrement.after(f.fireEventEntryAccess.rightCurlyBracketKeyword_4)
		c.setLinewrap.before(f.appAccess.appNameKeyword_1_0)
		c.setLinewrap.before(f.appAccess.defaultConnectionKeyword_2_0_0)
		
	}
	//Easter Egg: ()
}
