package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderEventType
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.ElementEventType
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.GlobalEventType
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.ValidatorBindingTask
import de.wwu.md2.framework.mD2.ValidatorUnbindTask
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.WorkflowElement
import java.lang.invoke.MethodHandles
import org.eclipse.emf.common.util.Enumerator
import de.wwu.md2.framework.mD2.ContentProviderReference

class IOSCustomAction {
	
	static var className = ""
	
	def static generateClass(CustomAction action) {
		className = Settings.PREFIX_CUSTOM_ACTION + (action.eContainer as WorkflowElement).name.toFirstUpper + "_" + action.name.toFirstUpper
		
		generateClassContent(action)
	} 
	
	def static generateClassContent(CustomAction action) '''
«GeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

class «className»: ActionType {
    
    let actionSignature: String = "«className»"
    
    func execute() {
        // Bindings/ Mappings / Call action / Set content provider / Conditions
	«FOR i : 1..action.codeFragments.length»
		«generateCodeFragment(i, action.codeFragments.get(i - 1))»
    «ENDFOR»
       
    }
    
    func equals(anotherAction: ActionType) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
}
	'''
	
	def static generateCodeFragment(int actionCounter, CustomCodeFragment fragment){
		// MARK incomplete list to be extended in future version
		switch fragment {
			CallTask: return generateCallTask(actionCounter, (fragment as CallTask))
			AttributeSetTask: return generateAttributeSetTask(actionCounter, (fragment as AttributeSetTask))
			EventBindingTask: return generateEventBindingTask(actionCounter, (fragment as EventBindingTask))
			EventUnbindTask: return generateEventUnbindTask(actionCounter, (fragment as EventUnbindTask))
			MappingTask: return generateMappingTaskTask(actionCounter, (fragment as MappingTask))
			UnmappingTask: return generateUnmappingTaskTask(actionCounter, (fragment as UnmappingTask))
			ValidatorBindingTask: return generateValidatorBindingTask(actionCounter, (fragment as ValidatorBindingTask))
			ValidatorUnbindTask: return generateValidatorUnbindTask(actionCounter, (fragment as ValidatorUnbindTask))
			default: GeneratorUtil.printError("IOSCustomAction encountered unsupported CustomCodeFragment type: " + fragment)
		}
	}
	
	def static generateCallTask(int actionCounter, CallTask task) '''
			
			let codeFragment«actionCounter» = «IOSAction.generateAction(className + "_" + actionCounter, task.action)».execute()
	'''
	
	def static generateAttributeSetTask(int actionCounter, AttributeSetTask task) '''
		«IF task.source instanceof ContentProviderReference»
			
			let codeFragment«actionCounter» = AssignObjectAction(actionSignature: actionSignature + "__«actionCounter»",
				assignContentProvider: ContentProviderRegistry.instance.getContentProvider("«(task.source as ContentProviderReference).contentProvider.name»")!,
				toProvider: ContentProviderRegistry.instance.getContentProvider("«task.pathDefinition.contentProviderRef.name»")!,
				attribute: "«task.pathDefinition.tail.attributeRef.name»")
			action.exeecute() 
		«ELSE»
		«GeneratorUtil.printError("IOSCustomAction encountered unsupported AttributeSetTask. Only ContentProviders are allowed as source!: " + task.source)»
		«ENDIF»
	'''
	
	def static generateEventBindingTask(int actionCounter, EventBindingTask task) '''
			
		«FOR i : 1..task.events.length»
		«FOR j : 1..task.actions.length»
			let codeFragment«actionCounter»_«i»_«j» = «IOSAction.generateAction(className + "_" + actionCounter + "_" + i + "_" + j, task.actions.get(j-1))»
			«generateEventHandler(task.events.get(i-1), "codeFragment" + actionCounter + "_" + i + "_" + j, true)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateEventUnbindTask(int actionCounter, EventUnbindTask task) '''
			
		«FOR i : 1..task.events.length»
		«FOR j : 1..task.actions.length»
			let codeFragment«actionCounter»_«i»_«j» = «IOSAction.generateAction(className + "_" + actionCounter + "_" + i + "_" + j, task.actions.get(j-1))»
			«generateEventHandler(task.events.get(i-1), "codeFragment" + actionCounter + "_" + i + "_" + j, false)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateMappingTaskTask(int actionCounter, MappingTask task) '''
		
		«IF task.pathDefinition instanceof ContentProviderPath»
		DataMapper.instance.map(
			WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(task.referencedViewField)»)!,
			contentProvider: ContentProviderRegistry.instance.getContentProvider("«(task.pathDefinition as ContentProviderPath).contentProviderRef.name»")!,
			attribute: "«(task.pathDefinition as ContentProviderPath).tail.attributeRef.name»")
        «ELSE»
        «GeneratorUtil.printError("IOSCustomAction encountered unsupported pathDefinition for MappingTask:" + task.pathDefinition)»
        «ENDIF»
	'''
	
	def static generateUnmappingTaskTask(int actionCounter, UnmappingTask task) '''
		
		«IF task.pathDefinition instanceof ContentProviderPath»
		DataMapper.instance.unmap(
			WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(task.referencedViewField)»)!,
			contentProvider: ContentProviderRegistry.instance.getContentProvider("«(task.pathDefinition as ContentProviderPath).contentProviderRef.name»")!,
			attribute: "«(task.pathDefinition as ContentProviderPath).tail.attributeRef.name»")
        «ELSE»
        «GeneratorUtil.printError("IOSCustomAction encountered unsupported pathDefinition for UnmappingTask:" + task.pathDefinition)»
        «ENDIF»
	'''
	
	def static generateValidatorBindingTask(int actionCounter, ValidatorBindingTask task) '''
			
		«FOR i : 1..task.referencedFields.length»
		«FOR j : 1..task.validators.length»
			let codeFragment«actionCounter»_«i»_«j» = «IOSValidator.generateValidator("validator" + actionCounter + "_" + i + "_" + j, task.validators.get(j-1))»
			WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(task.referencedFields.get(i - 1))»)!
				.addValidator(codeFragment«actionCounter»_«i»_«j»)
		«ENDFOR»
		«ENDFOR»
	'''
	
	// TODO unbind "allTypes" keyword
	def static generateValidatorUnbindTask(int actionCounter, ValidatorUnbindTask task) '''
			
		«FOR i : 1..task.referencedFields.length»
		«FOR j : 1..task.validators.length»
			let codeFragment«actionCounter»_«i»_«j» = «IOSValidator.generateValidator("validator" + actionCounter + "_" + i + "_" + j, task.validators.get(j-1))»
			WidgetRegistry.instance.getWidget(WidgetMapping.«IOSWidgetMapping.lookup(task.referencedFields.get(i - 1))»)!
				.removeValidator(codeFragment«actionCounter»_«i»_«j»)
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateEventHandler(EventDef event, String actionStringRef, boolean register) {
		val UnRegister = if (!register) { "un" } else { "" }
		var Enumerator eventType = null;
		
		switch event {
			ViewElementEventRef: eventType = (event as ViewElementEventRef).event
			ContentProviderEventRef: eventType = (event as ContentProviderEventRef).event
			GlobalEventRef: eventType = (event as GlobalEventRef).event
			default: {
				GeneratorUtil.printError("IOSCustomAction encountered unsupported EventDef: " + event)
				return ""
			}
		}
		
		switch eventType {
			case ElementEventType.ON_CLICK: {
				return "OnClickHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_CHANGE: {
				return "OnWidgetChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_LEFT_SWIPE: {
				return "OnLeftSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_RIGHT_SWIPE: {
				return "OnRightSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_WRONG_VALIDATION: {
				return "OnWrongValidationHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ContentProviderEventType.ON_CHANGE: {
				return "OnContentChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", contentProvider: ContentProviderRegistry.instance.getContentProvider('" 
					+ (event as ContentProviderEventRef).contentProvider 
					+ "')!, attribute: '')"
			}
			case GlobalEventType.ON_CONNECTION_LOST: {
				return "OnConnectionLostHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			case GlobalEventType.ON_CONNECTION_REGAINED: {
				return "OnConnectionRegainedHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			case GlobalEventType.ON_LOCATION_UPDATE: {
				return "OnLocationUpdateHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			default: GeneratorUtil.printError("IOSCustomAction encountered unsupported ElementEventType: " + event)
		}
	}
}