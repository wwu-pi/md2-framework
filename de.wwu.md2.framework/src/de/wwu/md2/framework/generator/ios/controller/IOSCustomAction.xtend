package de.wwu.md2.framework.generator.ios.controller

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.ConditionalExpressionUtil
import de.wwu.md2.framework.generator.ios.view.IOSWidgetMapping
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.ConditionalCodeFragment
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderEventType
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderReference
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
import java.lang.invoke.MethodHandles
import org.eclipse.emf.common.util.Enumerator
import de.wwu.md2.framework.generator.ios.util.SimpleExpressionUtil
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil

class IOSCustomAction {
	
	static var className = ""
	
	def static generateClass(CustomAction action) {
		className = Settings.PREFIX_CUSTOM_ACTION + MD2GeneratorUtil.getName(action).toFirstUpper
		
		generateClassContent(action)
	} 
	
	def static generateClassContent(CustomAction action) '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

class «className»: MD2ActionType {
    
    let actionSignature: String = "«className»"
    
    func execute() {
        // Bindings/ Mappings / Call action / Set content provider / Conditions
	«FOR i : 0..<action.codeFragments.length»
		«generateCodeFragment((i+1).toString, action.codeFragments.get(i))»
    «ENDFOR»
       
    }
    
    func equals(anotherAction: MD2ActionType) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
}
	'''
	
	def static CharSequence generateCodeFragment(String actionCounter, CustomCodeFragment fragment){
		// MARK incomplete list to be extended in future version
		switch fragment {
			CallTask: return generateCallTask(actionCounter, (fragment as CallTask))
			AttributeSetTask: return generateAttributeSetTask(actionCounter, fragment)
			EventBindingTask: return generateEventBindingTask(actionCounter, fragment)
			EventUnbindTask: return generateEventUnbindTask(actionCounter, fragment)
			MappingTask: return generateMappingTaskTask(actionCounter, fragment)
			UnmappingTask: return generateUnmappingTaskTask(actionCounter, fragment)
			ValidatorBindingTask: return generateValidatorBindingTask(actionCounter, fragment)
			ValidatorUnbindTask: return generateValidatorUnbindTask(actionCounter, fragment)
			ConditionalCodeFragment: return generateConditionalCodeFragment(actionCounter, fragment)
			default: {
				IOSGeneratorUtil.printError("IOSCustomAction encountered unsupported CustomCodeFragment type: " + fragment)
				return ""
			}
		}
	}
	
	def static generateCallTask(String actionCounter, CallTask task) '''
			
			let codeFragment«actionCounter» = «IOSAction.generateAction(className + "_" + actionCounter, task.action)»
			codeFragment«actionCounter».execute()
	'''
	
	def static generateAttributeSetTask(String actionCounter, AttributeSetTask task) '''
		«««Apparently ContentProviderSetTasks are also regarded as AttributeSetTasks here and need a case distinction»»
		«IF task.source instanceof ContentProviderReference»
		
			let codeFragment«actionCounter» = MD2AssignObjectAction(actionSignature: actionSignature + "__«actionCounter»",
				assignContentProvider: MD2ContentProviderRegistry.instance.getContentProvider("«(task.source as ContentProviderReference).contentProvider.name»")!,
				toContentProvider: MD2ContentProviderRegistry.instance.getContentProvider("«task.pathDefinition.contentProviderRef.name»")!,
				attribute: "«task.pathDefinition.tail.attributeRef.name»")
			codeFragment«actionCounter».execute() 
		«ELSE»
		«««Set a simple expression as value to a contentProvider»»»
		
			MD2ContentProviderRegistry.instance.getContentProvider("«task.pathDefinition.contentProviderRef.name»")!.setValue(
				"«task.pathDefinition.tail.attributeRef.name»",
				value: MD2String(«SimpleExpressionUtil.getStringValue(task.source)»)
			)
		«ENDIF»
		
	'''
	
	def static generateEventBindingTask(String actionCounter, EventBindingTask task) '''
			
		«FOR i : 0..<task.events.length»
		«FOR j : 0..<task.actions.length»
			let codeFragment«actionCounter»_«(i+1)»_«(j+1)» = «IOSAction.generateAction(className + "_" + actionCounter + "_" + (i+1) + "_" + (j+1), task.actions.get(j))»
			«generateEventHandler(task.events.get(i), "codeFragment" + actionCounter + "_" + (i+1) + "_" + (j+1), true)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateEventUnbindTask(String actionCounter, EventUnbindTask task) '''
			
		«FOR i : 0..<task.events.length»
		«FOR j : 0..<task.actions.length»
			let codeFragment«actionCounter»_«(i+1)»_«(j+1)» = «IOSAction.generateAction(className + "_" + actionCounter + "_" + (i+1) + "_" + (j+1), task.actions.get(j))»
			«generateEventHandler(task.events.get(i), "codeFragment" + actionCounter + "_" + (i+1) + "_" + (j+1), false)»
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateMappingTaskTask(String actionCounter, MappingTask task) '''
		
		«IF task.pathDefinition instanceof ContentProviderPath»
		MD2DataMapper.instance.map(
			MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(task.referencedViewField)»)!,
			contentProvider: MD2ContentProviderRegistry.instance.getContentProvider("«(task.pathDefinition as ContentProviderPath).contentProviderRef.name»")!,
			attribute: "«(task.pathDefinition as ContentProviderPath).tail.attributeRef.name»")
        «ELSE»
        «IOSGeneratorUtil.printError("IOSCustomAction encountered unsupported pathDefinition for MappingTask:" + task.pathDefinition)»
        «ENDIF»
	'''
	
	def static generateUnmappingTaskTask(String actionCounter, UnmappingTask task) '''
		
		«IF task.pathDefinition instanceof ContentProviderPath»
		MD2DataMapper.instance.unmap(
			MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(task.referencedViewField)»)!,
			contentProvider: MD2ContentProviderRegistry.instance.getContentProvider("«(task.pathDefinition as ContentProviderPath).contentProviderRef.name»")!,
			attribute: "«(task.pathDefinition as ContentProviderPath).tail.attributeRef.name»")
        «ELSE»
        «IOSGeneratorUtil.printError("IOSCustomAction encountered unsupported pathDefinition for UnmappingTask:" + task.pathDefinition)»
        «ENDIF»
	'''
	
	def static generateValidatorBindingTask(String actionCounter, ValidatorBindingTask task) '''
			
		«FOR i : 0..<task.referencedFields.length»
		«FOR j : 0..<task.validators.length»
			let codeFragment«actionCounter»_«(i+1)»_«(j+1)» = «IOSValidator.generateValidator("validator" + actionCounter + "_" + (i+1) + "_" + (j+1), task.validators.get(j))»
			MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(task.referencedFields.get(i))»)!
				.addValidator(codeFragment«actionCounter»_«(i+1)»_«(j+1)»)
		«ENDFOR»
		«ENDFOR»
	'''
	
	// TODO unbind "allTypes" keyword
	def static generateValidatorUnbindTask(String actionCounter, ValidatorUnbindTask task) '''
			
		«FOR i : 0..<task.referencedFields.length»
		«FOR j : 0..<task.validators.length»
			let codeFragment«actionCounter»_«(i+1)»_«(j+1)» = «IOSValidator.generateValidator("validator" + actionCounter + "_" + (i+1) + "_" + (j+1), task.validators.get(j))»
			MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.«IOSWidgetMapping.lookup(task.referencedFields.get(i))»)!
				.removeValidator(codeFragment«actionCounter»_«(i+1)»_«(j+1)»)
		«ENDFOR»
		«ENDFOR»
	'''
	
	def static generateConditionalCodeFragment(String actionCounter, ConditionalCodeFragment fragment) '''
			
			if «ConditionalExpressionUtil.getStringRepresentation(fragment.^if.condition)» {
				«FOR i : 0..<fragment.^if.codeFragments.length»
				«generateCodeFragment(actionCounter + "_if_" + i, fragment.^if.codeFragments.get(i))»
				«ENDFOR»
			}
			«FOR j : 0..<fragment.elseifs.length »
			else if «ConditionalExpressionUtil.getStringRepresentation(fragment.elseifs.get(j).condition)» {
				«FOR i : 0..<fragment.elseifs.get(j).codeFragments.length»
				«generateCodeFragment(actionCounter + "_elseif_" + j + "_" + i, fragment.elseifs.get(j).codeFragments.get(i))»
				«ENDFOR»
			}
			«ENDFOR»
			else {
			«IF fragment.^else != null»
				«FOR i : 0..<fragment.^else.codeFragments.length»
				«generateCodeFragment(actionCounter + "_else_" + i, fragment.^else.codeFragments.get(i))»
				«ENDFOR»
			«ENDIF»
			}
	'''
	
	def static generateEventHandler(EventDef event, String actionStringRef, boolean register) {
		val UnRegister = if (!register) { "un" } else { "" }
		var Enumerator eventType = null;
		
		switch event {
			ViewElementEventRef: eventType = (event as ViewElementEventRef).event
			ContentProviderEventRef: eventType = (event as ContentProviderEventRef).event
			GlobalEventRef: eventType = (event as GlobalEventRef).event
			default: {
				IOSGeneratorUtil.printError("IOSCustomAction encountered unsupported EventDef: " + event)
				return ""
			}
		}
		
		switch eventType {
			case ElementEventType.ON_CLICK: {
				return "MD2OnClickHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_CHANGE: {
				return "MD2OnWidgetChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_LEFT_SWIPE: {
				return "MD2OnLeftSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_RIGHT_SWIPE: {
				return "MD2OnRightSwipeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ElementEventType.ON_WRONG_VALIDATION: {
				return "MD2OnWrongValidationHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", widget: MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping." 
					+ IOSWidgetMapping.lookup((event as ViewElementEventRef).referencedField) + ")!)"
			}
			case ContentProviderEventType.ON_CHANGE: {
				return "MD2OnContentChangeHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ", contentProvider: MD2ContentProviderRegistry.instance.getContentProvider('" 
					+ (event as ContentProviderEventRef).contentProvider 
					+ "')!, attribute: '')"
			}
			case GlobalEventType.ON_CONNECTION_LOST: {
				return "MD2OnConnectionLostHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			case GlobalEventType.ON_CONNECTION_REGAINED: {
				return "MD2OnConnectionRegainedHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			case GlobalEventType.ON_LOCATION_UPDATE: {
				return "MD2OnLocationUpdateHandler.instance." + UnRegister + "registerAction(" + actionStringRef 
					+ ")"
			}
			default: IOSGeneratorUtil.printError("IOSCustomAction encountered unsupported ElementEventType: " + event)
		}
	}
}