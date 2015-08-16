package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.impl.CallTaskImpl
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.impl.ContentProviderSetTaskImpl
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.impl.EventBindingTaskImpl
import de.wwu.md2.framework.mD2.impl.EventUnbindTaskImpl
import de.wwu.md2.framework.mD2.impl.MappingTaskImpl
import de.wwu.md2.framework.mD2.impl.UnmappingTaskImpl
import de.wwu.md2.framework.mD2.impl.ValidatorBindingTaskImpl
import de.wwu.md2.framework.mD2.impl.ValidatorUnbindTaskImpl
import de.wwu.md2.framework.mD2.impl.ViewElementSetTaskImpl
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.impl.ViewElementEventRefImpl
import de.wwu.md2.framework.mD2.impl.GlobalEventRefImpl
import de.wwu.md2.framework.mD2.impl.ContentProviderEventRefImpl
import de.wwu.md2.framework.mD2.ElementEventType
import org.eclipse.emf.common.util.Enumerator
import de.wwu.md2.framework.mD2.ContentProviderEventType
import de.wwu.md2.framework.mD2.GlobalEventType
import de.wwu.md2.framework.generator.ios.model.WidgetMapping
import de.wwu.md2.framework.mD2.impl.SimpleActionRefImpl

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
		switch fragment {
			CallTaskImpl: return generateCallTask(actionCounter, (fragment as CallTaskImpl))
			ContentProviderSetTaskImpl: return generateContentProviderSetTaskImpl(actionCounter, (fragment as ContentProviderSetTaskImpl))
			EventBindingTaskImpl: return generateEventBindingTask(actionCounter, (fragment as EventBindingTaskImpl))
			EventUnbindTaskImpl: return generateEventUnbindTask(actionCounter, (fragment as EventUnbindTaskImpl))
			MappingTaskImpl: return generateMappingTaskTask(actionCounter, (fragment as MappingTaskImpl))
			UnmappingTaskImpl: return generateUnmappingTaskTask(actionCounter, (fragment as UnmappingTaskImpl))
			ValidatorBindingTaskImpl: return generateValidatorBindingTask(actionCounter, (fragment as ValidatorBindingTaskImpl))
			ValidatorUnbindTaskImpl: return generateValidatorUnbindTask(actionCounter, (fragment as ValidatorUnbindTaskImpl))
			ViewElementSetTaskImpl: return generateViewElementSetTask(actionCounter, (fragment as ViewElementSetTaskImpl))
			// TODO: AttributeSetTask, ConditionalCodeFragments
			default: GeneratorUtil.printError("IOSCustomAction encountered unsupported CustomCodeFragment type: " + fragment)
		}
	}
	
	def static generateCallTask(int actionCounter, CallTaskImpl task) '''
			let codeFragment«actionCounter» = «task.action»
	'''
	
	def static generateContentProviderSetTaskImpl(int actionCounter, ContentProviderSetTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task» //TODO
	'''
	
	def static generateEventBindingTask(int actionCounter, EventBindingTaskImpl task) '''
		«FOR i : 1..task.events.length»
		«FOR j : 1..task.actions.length»
			let codeFragment«actionCounter»_«i»_«j» = «IOSAction.generateAction(actionCounter + "_" + i + "_" + j, task.actions.get(j-1))»
			«generateEventHandler(task.events.get(i-1), "codeFragment" + actionCounter + "_" + i + "_" + j, true)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateEventUnbindTask(int actionCounter, EventUnbindTaskImpl task) '''
		«FOR i : 1..task.events.length»
		«FOR j : 1..task.actions.length»
			let codeFragment«actionCounter»_«i»_«j» = «task.actions.get(j-1)»
			«generateEventHandler(task.events.get(i-1), "codeFragment" + actionCounter + "_" + i + "_" + j, false)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateMappingTaskTask(int actionCounter, MappingTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task»
	'''
	
	def static generateUnmappingTaskTask(int actionCounter, UnmappingTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task»
	'''
	
	def static generateValidatorBindingTask(int actionCounter, ValidatorBindingTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task»
	'''
	
	def static generateValidatorUnbindTask(int actionCounter, ValidatorUnbindTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task»
	'''
	
	def static generateViewElementSetTask(int actionCounter, ViewElementSetTaskImpl task) '''
		//--	let codeFragment«actionCounter» = «task»
	'''
	
	def static generateEventHandler(EventDef event, String actionStringRef, boolean register) {
		val UnRegister = if (!register) { "un" } else { "" }
		var Enumerator eventType = null;
		
		// TODO: Support ConditionalEventRef, ContentProviderPathEventRef
		switch event {
			ViewElementEventRefImpl case event: eventType = (event as ViewElementEventRefImpl).event
			ContentProviderEventRefImpl case event: eventType = (event as ContentProviderEventRefImpl).event
			GlobalEventRefImpl case event: eventType = (event as GlobalEventRefImpl).event
			default: GeneratorUtil.printError("IOSCustomAction encountered unsupported EventBindingTask: " + event) // TODO
		}
		
		switch eventType {
			case ElementEventType.ON_CLICK: {
				return "OnClickHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ WidgetMapping.lookup((event as ViewElementEventRefImpl).referencedField) + ")!)"
			}
			case ElementEventType.ON_CHANGE: {
				return "OnWidgetChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ WidgetMapping.lookup((event as ViewElementEventRefImpl).referencedField) + ")!)"
			}
			case ElementEventType.ON_LEFT_SWIPE: {
				return "OnLeftSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ WidgetMapping.lookup((event as ViewElementEventRefImpl).referencedField) + ")!)"
			}
			case ElementEventType.ON_RIGHT_SWIPE: {
				return "OnRightSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ WidgetMapping.lookup((event as ViewElementEventRefImpl).referencedField) + ")!)"
			}
			case ElementEventType.ON_WRONG_VALIDATION: {
				return "OnWrongValidationHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: WidgetRegistry.instance.getWidget(WidgetMapping." 
					+ WidgetMapping.lookup((event as ViewElementEventRefImpl).referencedField) + ")!)"
			}
			case ContentProviderEventType.ON_CHANGE: {
				return "OnContentChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", contentProvider: ContentProviderRegistry.instance.getContentProvider('" 
					+ (event as ContentProviderEventRefImpl).contentProvider 
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
			default: GeneratorUtil.printError("IOSCustomAction encountered unsupported ElementEventType: " + event) // TODO
		}
	}
	
	def lalala () '''
	DisplayMessageAction(actionSignature: actionSignature + "__actionCounter", message: "Why the hell have you visited " + WidgetRegistry.instance.getWidget(WidgetMapping.LocationDetectionView_CityValue)!.value.toString() + "???")

	 let action1 = AssignObjectAction(actionSignature: actionSignature + "__1",
            assignContentProvider: ContentProviderRegistry.instance.getContentProvider("AddressProvider")!,
            toContentProvider: ContentProviderRegistry.instance.getContentProvider("ComplaintProvider")!,
            attribute: "loc")
        action1.execute()
        
        let action2 = ContentProviderOperationAction(actionSignature: actionSignature + "__2", allowedOperation: ContentProviderOperationAction.AllowedOperation.Save, contentProvider: ContentProviderRegistry.instance.getContentProvider("ComplaintProvider")!)
        action2.execute()

        '''
}