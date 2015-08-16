package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.mD2.impl.SimpleActionRefImpl
import de.wwu.md2.framework.mD2.impl.ProcessChainProceedActionImpl
import de.wwu.md2.framework.mD2.impl.GotoViewActionImpl
import de.wwu.md2.framework.mD2.impl.DisplayMessageActionImpl
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.mD2.SimpleAction

class IOSAction {
	
	// TODO support LocationAction
	def static generateAction(String actionSignature, ActionDef action) {
		if (action instanceof SimpleActionRefImpl) {
			return generateSimpleAction(actionSignature, action as SimpleActionRefImpl)
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
	
	def static generateSimpleAction(String actionSignature, SimpleActionRefImpl action) {
		switch (action as SimpleActionRefImpl) {
			case GotoViewActionImpl: return (action.action as GotoViewActionImpl).view
			case DisplayMessageActionImpl: return generateDisplayMessageAction(actionSignature, action.action as DisplayMessageActionImpl)
			default: return action.action
		}
	}
	
	def static generateDisplayMessageAction(String actionSignature, DisplayMessageActionImpl action) '''
		DisplayMessageAction(actionSignature: "«actionSignature»", message: "«action.message»")
	'''
}