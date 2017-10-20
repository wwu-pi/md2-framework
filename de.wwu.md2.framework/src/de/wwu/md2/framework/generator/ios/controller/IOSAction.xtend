package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.generator.ios.util.SimpleExpressionUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil
import de.wwu.md2.framework.mD2.Action
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderResetAction
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.DisableAction
import de.wwu.md2.framework.mD2.DisplayMessageAction
import de.wwu.md2.framework.mD2.EnableAction
import de.wwu.md2.framework.mD2.FireEventAction
import de.wwu.md2.framework.mD2.GotoViewAction
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.WebServiceCallAction

/**
 * Generate action declarations.
 */
class IOSAction {
	
	/**
	 * Generates an action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare an action instance. 
	 */
	def static CharSequence generateAction(String actionSignature, ActionDef action) {
		switch action {
			SimpleActionRef: return generateSimpleAction(actionSignature, action as SimpleActionRef)
			ActionReference: return generateAction(actionSignature, (action as ActionReference).actionRef)
			default: {
				IOSGeneratorUtil.printError("IOSAction encountered unknown action: " + action)
				return ""
			}
		}
	}
	
	/**
	 * Generates an action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare an action instance. 
	 */
	def static CharSequence generateAction(String actionSignature, Action action) {
		switch action {
			CombinedAction: return generateCombinedAction(actionSignature, action as CombinedAction)
			CustomAction: return generateCustomAction(actionSignature, action as CustomAction)
		}
	}
	
	/**
	 * Generates a simple action action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare an action instance. 
	 */
	def static CharSequence generateSimpleAction(String actionSignature, SimpleActionRef action) {
		switch action.action {
			GotoViewAction: return generateGotoViewAction(actionSignature, action.action as GotoViewAction)
			DisableAction: return generateDisableAction(actionSignature, action.action as DisableAction)
			EnableAction: return generateEnableAction(actionSignature, action.action as EnableAction)
			DisplayMessageAction: return generateDisplayMessageAction(actionSignature, action.action as DisplayMessageAction)
			ContentProviderOperationAction: return generateContentProviderOperationAction(actionSignature, action.action as ContentProviderOperationAction)
			ContentProviderResetAction: return generateContentProviderResetAction(actionSignature, action.action as ContentProviderResetAction)
			FireEventAction: return generateFireEventAction(actionSignature, action.action as FireEventAction)
			WebServiceCallAction: return generateWebServiceCallAction(actionSignature, action.action as WebServiceCallAction)
			default: { 
				IOSGeneratorUtil.printError("IOSAction encountered an unknown simple action: " + action.action)
				return ""
			}
		}
	}
	
	/**
	 * Template to generate a goToView action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateGotoViewAction(String actionSignature, GotoViewAction action) '''
		MD2GotoViewAction(actionSignature: "«actionSignature»", 
			targetView: MD2WidgetMapping.«action.view.ref.name»)
	'''
	
	/**
	 * Template to generate a view element disable action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateDisableAction(String actionSignature, DisableAction action) '''
		MD2DisableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«MD2GeneratorUtil.getName(action.inputField.ref)»)!)
	'''
	
	/**
	 * Template to generate a view element enable action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateEnableAction(String actionSignature, EnableAction action) '''
		MD2EnableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«MD2GeneratorUtil.getName(action.inputField.ref)»)!)
	'''
	
	/**
	 * Template to generate a display message action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateDisplayMessageAction(String actionSignature, DisplayMessageAction action) '''
		MD2DisplayMessageAction(actionSignature: "«actionSignature»", 
			message: «SimpleExpressionUtil.getStringValue(action.message)»)
	'''
	
	/**
	 * Template to generate a content provider operation action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateContentProviderOperationAction(String actionSignature, ContentProviderOperationAction action) '''
		MD2ContentProviderOperationAction(actionSignature: "«actionSignature»", 
			allowedOperation: MD2ContentProviderOperationAction.AllowedOperation.«action.operation.toString.toLowerCase.toFirstUpper»,
			contentProvider: MD2ContentProviderRegistry.instance.getContentProvider(
			«IF action.contentProvider instanceof ContentProviderReference»
				"«(action.contentProvider as ContentProviderReference).contentProvider.name»"
			«ELSEIF action.contentProvider instanceof LocationProviderReference»
				"location"
			«ELSE»
				«IOSGeneratorUtil.printError("IOSAction encountered unknown AbstractProviderReference: " + action.contentProvider)»
			«ENDIF»
			)!)
	'''
	
	/**
	 * Template to generate a content provider reset action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateContentProviderResetAction(String actionSignature, ContentProviderResetAction action) '''
		MD2ContentProviderResetAction(actionSignature: "«actionSignature»", 
			contentProvider: MD2ContentProviderRegistry.instance.getContentProvider(
			«IF action.contentProvider instanceof ContentProviderReference»
				"«(action.contentProvider as ContentProviderReference).contentProvider.name»"
			«ELSEIF action.contentProvider instanceof LocationProviderReference»
				"location"
			«ELSE»
				«IOSGeneratorUtil.printError("IOSAction encountered unknown AbstractProviderReference: " + action.contentProvider)»
			«ENDIF»
			)!)
	'''
	
	/**
	 * Template to generate a fireEvent action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateFireEventAction(String actionSignature, FireEventAction action) '''
		MD2FireEventAction(actionSignature: "«actionSignature»", 
			event: MD2WorkflowEvent.«action.workflowEvent.name»)
	'''
		
	/**
	 * Generate a web service call action declaration.
	 * TODO Not implemented yet
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateWebServiceCallAction(String actionSignature, WebServiceCallAction action) {
		IOSGeneratorUtil.printError("IOSAction: WebServiceCallAction unsupported")
		return '''MD2WebserviceCallAction(actionSignature: "«actionSignature»", webserviceCall: «action.webServiceCall»)'''
	}
	
	/**
	 * Template to generate a combined action declaration and its contained action list recursively.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateCombinedAction(String actionSignature, CombinedAction action) '''
		MD2CombinedAction(actionSignature: "«actionSignature»", actionList: [«FOR actionItem : action.actions SEPARATOR ', '»«IOSAction.generateAction(actionSignature + actionItem.name, actionItem)»«ENDFOR»])
	'''
	
	/**
	 * Template to generate a custom action declaration.
	 * 
	 * @param actionSignature The unique identifier of the action instance.
	 * @param action The action element to create.
	 * @return The Swift code to declare a action instance. 
	 */
	def static generateCustomAction(String actionSignature, CustomAction action) '''
		«Settings.PREFIX_CUSTOM_ACTION + MD2GeneratorUtil.getName(action)»()
	'''
}