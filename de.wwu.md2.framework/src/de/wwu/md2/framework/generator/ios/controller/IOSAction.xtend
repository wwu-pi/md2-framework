package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.ios.util.SimpleExpressionUtil
import de.wwu.md2.framework.mD2.ActionDef
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
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping
import de.wwu.md2.framework.mD2.Controller

class IOSAction {
	
	def static generateAction(String actionSignature, ActionDef action) {
		switch action {
			SimpleActionRef: return generateSimpleAction(actionSignature, action as SimpleActionRef)
			ActionReference: {
				switch ((action as ActionReference).actionRef) {
					CombinedAction: return generateCombinedAction(actionSignature, action.actionRef as CombinedAction)
					CustomAction: return generateCustomAction(actionSignature, action.actionRef as CustomAction)
					default: GeneratorUtil.printError("IOSAction encountered unknown action reference: " + action.actionRef)
				}
			}
			default: GeneratorUtil.printError("IOSAction encountered unknown action: " + action)
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
			default: GeneratorUtil.printError("IOSAction encountered an unknown simple action: " + action.action)
		}
	}
	
	def static generateGotoViewAction(String actionSignature, GotoViewAction action) '''
		GoToViewAction(actionSignature: "«actionSignature»", 
			webserviceCall:WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(action.view)»)!)
	'''
	
	def static generateDisableAction(String actionSignature, DisableAction action) '''
		DisableAction(actionSignature: "«actionSignature»", 
			viewElement: WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(action.inputField)»)!)
	'''
	
	def static generateEnableAction(String actionSignature, EnableAction action) '''
		EnableAction(actionSignature: "«actionSignature»", 
			viewElement: WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(action.inputField)»)!)
	'''
	
	def static generateDisplayMessageAction(String actionSignature, DisplayMessageAction action) '''
		DisplayMessageAction(actionSignature: "«actionSignature»", message: «SimpleExpressionUtil.getStringValue(action.message)»)
	'''
	
	def static generateContentProviderOperationAction(String actionSignature, ContentProviderOperationAction action) '''
		ContentProviderOperationAction(actionSignature: "«actionSignature»", 
			allowedOperation: ContentProviderOperationAction.AllowedOperation.«action.operation.toString.toUpperCase»,
			contentProvider: ContentProviderRegistry.instance.getContentProvider(contentProviderName: 
			«IF action.contentProvider instanceof ContentProviderReference»
				"«(action.contentProvider as ContentProviderReference).contentProvider.name»"
			«ELSEIF action.contentProvider instanceof LocationProviderReference»
				"location"
			«ELSE»
				«GeneratorUtil.printError("IOSAction encountered unknown AbstractProviderReference: " + action.contentProvider)»
			«ENDIF»
			)!)
	'''
	
	def static generateContentProviderResetAction(String actionSignature, ContentProviderResetAction action) '''
		ContentProviderResetAction(actionSignature: "«actionSignature»", 
			contentProvider: ContentProviderRegistry.instance.getContentProvider(contentProviderName: 
			«IF action.contentProvider instanceof ContentProviderReference»
				"«(action.contentProvider as ContentProviderReference).contentProvider.name»"
			«ELSEIF action.contentProvider instanceof LocationProviderReference»
				"location"
			«ELSE»
				«GeneratorUtil.printError("IOSAction encountered unknown AbstractProviderReference: " + action.contentProvider)»
			«ENDIF»
			)!)
	'''
	
	def static generateFireEventAction(String actionSignature, FireEventAction action) '''
		FireEventAction(actionSignature: "«actionSignature»", 
			event: WorkflowEvent.«action.workflowEvent.name»)
	'''
		
	// TODO WebServiceCall
	def static generateWebServiceCallAction(String actionSignature, WebServiceCallAction action) '''
		WebserviceCallAction(actionSignature: "«actionSignature»", webserviceCall: «action.webServiceCall»)
	'''
	
	// TODO CombinedAction
	def static generateCombinedAction(String actionSignature, CombinedAction action) {
		GeneratorUtil.printError("IOSAction: CombinedAction unsupported")
		return ""
	}
	
	def static generateCustomAction(String actionSignature, CustomAction action) '''
		«IF action.eContainer instanceof WorkflowElement»
		«Settings.PREFIX_CUSTOM_ACTION + (action.eContainer as WorkflowElement).name.toFirstUpper + "_" + action.name.toFirstUpper»()
		«ELSEIF action.eContainer instanceof Controller»
		«Settings.PREFIX_CUSTOM_ACTION + "Controller_" + action.name.toFirstUpper»()
		«ELSEIF action.eContainer == null»
		«Settings.PREFIX_CUSTOM_ACTION + action.name.toFirstUpper»()
		«ELSE»
		«GeneratorUtil.printError("IOSAction encountered unknown custom action:" + action)»
		«ENDIF»
	'''
}