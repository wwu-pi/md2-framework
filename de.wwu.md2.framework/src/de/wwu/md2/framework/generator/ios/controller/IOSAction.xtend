package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.ios.util.SimpleExpressionUtil
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.impl.SimpleActionRefImpl
import de.wwu.md2.framework.mD2.SimpleActionRef

class IOSAction {
	
	// TODO support LocationAction
	def static generateAction(String actionSignature, ActionDef action) {
		if (action instanceof SimpleActionRefImpl) {
			return generateSimpleAction(actionSignature, action as SimpleActionRef)
		} else {
			// TODO
			GeneratorUtil.printError("IOSAction: This is not a simple action: " + action)
			return ""
		}
	}
	// core actions that have to be supported by the platform
	/*{GotoViewAction} ('GotoView' '(' view = AbstractViewGUIElementRef ')' ) |
	{DisableAction} ('Disable' '(' inputField = AbstractViewGUIElementRef ')' ) |
	{EnableAction} ('Enable' '(' inputField = AbstractViewGUIElementRef ')' ) |
	{DisplayMessageAction} ('DisplayMessage' '(' message = SimpleExpression ')' ) |
	{ContentProviderOperationAction} ('ContentProviderOperation' '(' operation = AllowedOperation contentProvider = AbstractProviderReference ')') |
	{ContentProviderResetAction} ('ContentProviderReset' '('contentProvider = ContentProviderReference ')') |
	{FireEventAction} ('FireEvent' '('workflowEvent = WorkflowEvent')') |
	{WebServiceCallAction} ('WebServiceCall' webServiceCall = [WebServiceCall]) |
	*/
	
	def static generateSimpleAction(String actionSignature, SimpleActionRef action) {
		switch action.action {
			GotoViewAction: return (action.action as GotoViewAction).view
			DisplayMessageAction: return generateDisplayMessageAction(actionSignature, action.action as DisplayMessageAction)
			default: return action.action.class.name
		}
	}
	
	def static generateDisplayMessageAction(String actionSignature, DisplayMessageAction action) '''
		DisplayMessageAction(actionSignature: "«actionSignature»", message: "«SimpleExpressionUtil.getStringValue(action.message)»")
	'''
}