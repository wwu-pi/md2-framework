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

class IOSAction {
	
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
	
	def static CharSequence generateAction(String actionSignature, Action action) {
		switch action {
			CombinedAction: return generateCombinedAction(actionSignature, action as CombinedAction)
			CustomAction: return generateCustomAction(actionSignature, action as CustomAction)
		}
	}
	
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
	
	def static generateGotoViewAction(String actionSignature, GotoViewAction action) '''
		MD2GotoViewAction(actionSignature: "«actionSignature»", 
			targetView: MD2WidgetMapping.«MD2GeneratorUtil.getName(action.view.ref)»)
	'''
	
	def static generateDisableAction(String actionSignature, DisableAction action) '''
		MD2DisableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«MD2GeneratorUtil.getName(action.inputField.ref)»)!)
	'''
	
	def static generateEnableAction(String actionSignature, EnableAction action) '''
		MD2EnableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«MD2GeneratorUtil.getName(action.inputField.ref)»)!)
	'''
	
	def static generateDisplayMessageAction(String actionSignature, DisplayMessageAction action) '''
		MD2DisplayMessageAction(actionSignature: "«actionSignature»", 
			message: «SimpleExpressionUtil.getStringValue(action.message)»)
	'''
	
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
	
	def static generateFireEventAction(String actionSignature, FireEventAction action) '''
		MD2FireEventAction(actionSignature: "«actionSignature»", 
			event: MD2WorkflowEvent.«action.workflowEvent.name»)
	'''
		
	// TODO WebServiceCall
	def static generateWebServiceCallAction(String actionSignature, WebServiceCallAction action) {
		IOSGeneratorUtil.printError("IOSAction: WebServiceCallAction unsupported")
		return '''MD2WebserviceCallAction(actionSignature: "«actionSignature»", webserviceCall: «action.webServiceCall»)'''
	}
	
	def static generateCombinedAction(String actionSignature, CombinedAction action) '''
		MD2CombinedAction(actionSignature: "«actionSignature»", actionList: [«FOR actionItem : action.actions SEPARATOR ', '»«IOSAction.generateAction(actionSignature + actionItem.name, actionItem)»«ENDFOR»])
	'''
	
	def static generateCustomAction(String actionSignature, CustomAction action) '''
		«Settings.PREFIX_CUSTOM_ACTION + MD2GeneratorUtil.getName(action)»()
	'''
}