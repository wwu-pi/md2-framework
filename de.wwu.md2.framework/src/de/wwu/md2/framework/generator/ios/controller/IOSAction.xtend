package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.generator.ios.util.SimpleExpressionUtil
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping
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
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil

class IOSAction {
	
	def static generateAction(String actionSignature, ActionDef action) {
		switch action {
			SimpleActionRef: return generateSimpleAction(actionSignature, action as SimpleActionRef)
			ActionReference: {
				switch ((action as ActionReference).actionRef) {
					CombinedAction: return generateCombinedAction(actionSignature, action.actionRef as CombinedAction)
					CustomAction: return generateCustomAction(actionSignature, action.actionRef as CustomAction)
					default: IOSGeneratorUtil.printError("IOSAction encountered unknown action reference: " + action.actionRef)
				}
			}
			default: IOSGeneratorUtil.printError("IOSAction encountered unknown action: " + action)
		}
	}
	
	def static generateSimpleAction(String actionSignature, SimpleActionRef action) {
		switch action.action {
			GotoViewAction: return generateGotoViewAction(actionSignature, action.action as GotoViewAction)
			DisableAction: return generateDisableAction(actionSignature, action.action as DisableAction)
			EnableAction: return generateEnableAction(actionSignature, action.action as EnableAction)
			DisplayMessageAction: return generateDisplayMessageAction(actionSignature, action.action as DisplayMessageAction)
			ContentProviderOperationAction: return generateContentProviderOperationAction(actionSignature, action.action as ContentProviderOperationAction)
			ContentProviderResetAction: return generateContentProviderResetAction(actionSignature, action.action as ContentProviderResetAction)
			FireEventAction: return generateFireEventAction(actionSignature, action.action as FireEventAction)
			WebServiceCallAction: return generateWebServiceCallAction(actionSignature, action.action as WebServiceCallAction)
			default: IOSGeneratorUtil.printError("IOSAction encountered an unknown simple action: " + action.action)
		}
	}
	
	def static generateGotoViewAction(String actionSignature, GotoViewAction action) '''
		MD2GotoViewAction(actionSignature: "«actionSignature»", 
			targetView: MD2WidgetMapping.«IOSWidgetMapping.lookup(action.view)»)
	'''
	
	def static generateDisableAction(String actionSignature, DisableAction action) '''
		MD2DisableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(action.inputField)»)!)
	'''
	
	def static generateEnableAction(String actionSignature, EnableAction action) '''
		MD2EnableAction(actionSignature: "«actionSignature»", 
			viewElement: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(action.inputField)»)!)
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
	def static generateWebServiceCallAction(String actionSignature, WebServiceCallAction action) '''
		MD2WebserviceCallAction(actionSignature: "«actionSignature»", webserviceCall: «action.webServiceCall»)
	'''
	
	// TODO CombinedAction
	def static generateCombinedAction(String actionSignature, CombinedAction action) {
		IOSGeneratorUtil.printError("IOSAction: CombinedAction unsupported")
		return ""
	}
	
	def static generateCustomAction(String actionSignature, CustomAction action) '''
		«Settings.PREFIX_CUSTOM_ACTION + MD2GeneratorUtil.getName(action)»()
	'''
}