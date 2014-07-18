package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.Boolean
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventType
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.ElementEventType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.OnConditionEvent
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.SimpleActionRef
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

/**
 * TODO documentation
 */
class ProcessCustomEvents {
	
	/**
	 * main step that calls all substeps
	 * 
	 * dependencies: transformWorkflowsToSequenceOfCoreLanguageElements - This step night create new customEvents that have to be transformed
	 */
	def static void transformAllCustomEventsToBasicLanguageStructures(MD2Factory factory, ResourceSet workingInput) {
		
		// only run this task if there are conditional events present
		val hasConditionalEvents = workingInput.resources.map[ r |
			r.allContents.toIterable.findFirst( e | e instanceof OnConditionEvent)
		].exists(e | e != null)
		
		if (!hasConditionalEvents) {
			return
		}
		
		// get all event binding and event unbinding tasks that refer to custom events
		val customEventBindings = workingInput.resources.map[ r |
			r.allContents.toIterable
				.filter(typeof(EventBindingTask))
				.filter(bindingTask | bindingTask.events.exists(eventType | eventType instanceof ConditionalEventRef))
		].flatten
		
		val customEventUnbindings = workingInput.resources.map[ r |
			r.allContents.toIterable
				.filter(typeof(EventUnbindTask))
				.filter(unbindingTask | unbindingTask.events.exists(eventType | eventType instanceof ConditionalEventRef))
		].flatten
		
		// All sub steps
		val allEventActionTuples = createAllEventActionTuples(factory, workingInput, customEventBindings, customEventUnbindings)
		val mappingEntity = createEntity(factory, workingInput, allEventActionTuples);
		val contentProvider = createContentProviderForEntity(factory, workingInput, mappingEntity)
		createCustomActionForEachConditionalEvent(factory, workingInput, allEventActionTuples, contentProvider, mappingEntity)
		createCustomActionToRegisterConditionalEvents(factory, workingInput, allEventActionTuples)
		replaceCustomEventBindingsWithSettersForMappingEntity(factory, workingInput, customEventBindings, customEventUnbindings, contentProvider, mappingEntity)
		removeOnConditionalEvents(factory, workingInput, allEventActionTuples)
	}
	
	/**
	 * Generate string identifiers for each event->action mapping and store them in a nested HashMap of the form
	 * (event => [identifier => action]) that is used in later steps to get all actions that are mapped to a certain event.
	 * The string identifiers assure that each event->action mapping is only stored once (it is not considered whether a mapping
	 * is a binding or unbinding task).
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>transformEventBindingAndUnbindingTasksToOneToOneRelations</i> - This step relies on the aspect that each mapping consists of exactly one activity
	 *     and one event (using .last without checking the size of each events/actions list).
	 *   </li>
	 *   <li>
	 *     <i>calculateParameterSignatureForAllSimpleActions</i> - Required to create identifiers for each simple action.
	 *   </li>
	 * </ul>
	 */
	def private static createAllEventActionTuples(
		MD2Factory factory, ResourceSet workingInput, Iterable<EventBindingTask> customEventBindings,
		Iterable<EventUnbindTask> customEventUnbindings
	) {
		
		val allEventActionTuples = newHashMap
		
		customEventBindings.forEach[ binding |
			val action = binding.actions.get(0)
			val conditionalEvent = (binding.events.last as ConditionalEventRef).eventReference
			
			if(allEventActionTuples.get(conditionalEvent) == null) {
				allEventActionTuples.put(conditionalEvent, newHashMap)
			}
			
			allEventActionTuples.get(conditionalEvent).put(binding.mappingIdentifierHelper, action)
		]
		
		customEventUnbindings.forEach[ binding |
			val action = binding.actions.get(0)
			val conditionalEvent = (binding.events.last as ConditionalEventRef).eventReference
			
			if(allEventActionTuples.get(conditionalEvent) == null) {
				allEventActionTuples.put(conditionalEvent, newHashMap)
			}
			
			allEventActionTuples.get(conditionalEvent).put(binding.mappingIdentifierHelper, action)
		]
		
		return allEventActionTuples
	}
	
	/**
	 * Create an entity that stores all conditionalEvent Mappings and the current state
	 * (true: action is mapped to event | false: action is not mapped to event).
	 *
	 * Structure:
	 * <pre>
	 * entity __CustomEventMappings {
	 *   myAction1_myCustomEvent1 : BOOLEAN
	 *   myAction1_myCustomEvent2 : BOOLEAN
	 *   myAction2_myCustomEvent1 : BOOLEAN
	 *   .
	 *   .
	 *   .
	 * }
	 * </pre>
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def private static createEntity(
		MD2Factory factory, ResourceSet workingInput, HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples
	) {
		val model = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Model))
		].flatten.last
		
		// create entity and populate it with attributes for each unique action->event mapping
		val mappingEntity = factory.createEntity
		mappingEntity.setName("__ConditionalEventMappings")
		
		allEventActionTuples.forEach[ event, map |
			map.forEach[ identifier, action |
				val attribute = factory.createAttribute
				val booleanType = factory.createBooleanType
				attribute.setName(identifier)
				attribute.setType(booleanType)
				mappingEntity.attributes.add(attribute)
			]
		]
		
		model.modelElements.add(mappingEntity)
		return mappingEntity
	}
	
	/**
	 * Create a local content provider for the <i>__ConditionalEventMappings</i> entity.
	 */
	def private static createContentProviderForEntity(MD2Factory factory, ResourceSet workingInput, Entity mappingEntity) {
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		val referencedModelType = factory.createReferencedModelType
		referencedModelType.setEntity(mappingEntity)
		
		val contentProvider = factory.createContentProvider
		contentProvider.setName("__conditionalEventMappingsProvider")
		contentProvider.setLocal(true)
		contentProvider.setType(referencedModelType)
		
		controller.controllerElements.add(contentProvider)
		
		return contentProvider
	}
	
	//   foreach CustomEvent: create CustomAction
	def private static createCustomActionForEachConditionalEvent(
		MD2Factory factory, ResourceSet workingInput,
		HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples,
		ContentProvider contentProvider, Entity mappingEntity
	) {
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		allEventActionTuples.forEach[ event, map |
			val customAction = factory.createCustomAction
			customAction.setName("__conditionalEvent_" + event.name)
			
			// add conditional code block with the original event.condition
			val eventConditionCodeFragment = factory.createConditionalCodeFragment
			val eventConditionIfBlock = factory.createIfCodeBlock
			eventConditionIfBlock.setCondition(event.condition.copy)
			eventConditionCodeFragment.setIf(eventConditionIfBlock)
			customAction.codeFragments.add(eventConditionCodeFragment)
			
			// create if conditions to check for each event->action mapping whether it is true (mapped).
			// In case it is true (the action is currently mapped to the conditional event), the actual action is called.
			map.forEach[ identifier, action |
				
				val mappingConditionalExpression = factory.createCompareExpression
				
				{				
					// eqLeft composition
					val contentProviderPathDefinition = factory.createContentProviderPath
					val pathTail = factory.createPathTail
					pathTail.setAttributeRef(mappingEntity.attributes.filter( a | a.name.equals(identifier)).last)
					contentProviderPathDefinition.setContentProviderRef(contentProvider)
					contentProviderPathDefinition.setTail(pathTail)
					
					// op composition
					val operator = Operator::EQUALS
					
					// eqRight composition
					val booleanVal = factory.createBooleanVal
					booleanVal.setValue(Boolean::TRUE)
					
					mappingConditionalExpression.setEqLeft(contentProviderPathDefinition)
					mappingConditionalExpression.setOp(operator)
					mappingConditionalExpression.setEqRight(booleanVal)
				}
				
				// create if condition
				val mappingCodeFragment = factory.createConditionalCodeFragment
				val mappingIfBlock = factory.createIfCodeBlock
				mappingIfBlock.setCondition(mappingConditionalExpression)
				mappingCodeFragment.setIf(mappingIfBlock)
				eventConditionIfBlock.codeFragments.add(mappingCodeFragment)
				
				// create call task and add to mappingIfBlock
				val callTask = factory.createCallTask
				callTask.setAction(action.copy)
				mappingIfBlock.codeFragments.add(callTask)
			]
			
			controller.controllerElements.add(customAction)
		]
	}
	
	//   foreach CustomEvent: create __registerCustomEventName action and add it to startUpAction
	// this is just to structure the code. All the event bindings could also be placed directly in the
	// startup action or in one single custom action
	def private static createCustomActionToRegisterConditionalEvents(
		MD2Factory factory, ResourceSet workingInput,
		HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples
	) {
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		allEventActionTuples.forEach[ event, map |
			val customAction = factory.createCustomAction
			customAction.setName("__conditionalEventRegister_" + event.name)
			
			// get all contentProviderPathes from event.condition
			val pathDefinitions = event.condition.eAllContents.toIterable.filter(typeof(ContentProviderPath))
			for (pathDefinition : pathDefinitions) {
				val eventBindingTask = factory.createEventBindingTask
				customAction.codeFragments.add(eventBindingTask)
				
				val actionDef = factory.createActionReference
				val action = controller.controllerElements.filter(typeof(CustomAction)).filter(a | a.name.equals("__conditionalEvent_" + event.name)).last
				actionDef.setActionRef(action)
				eventBindingTask.actions.add(actionDef)
				
				val eventRef = factory.createContentProviderPathEventRef
				eventRef.setPathDefinition(pathDefinition.copy)
				eventRef.setEvent(ContentProviderEventType::ON_CHANGE)
				eventBindingTask.events.add(eventRef)
			}
			
			// get all GUIElement references from event.condition
			val guiElementRefs = event.condition.eAllContents.toIterable.filter(typeof(AbstractViewGUIElementRef))
			for (guiElementRef : guiElementRefs) {
				val eventBindingTask = factory.createEventBindingTask
				customAction.codeFragments.add(eventBindingTask)
				
				val actionDef = factory.createActionReference
				val action = controller.controllerElements.filter(typeof(CustomAction)).filter(a | a.name.equals("__conditionalEvent_" + event.name)).last
				actionDef.setActionRef(action)
				eventBindingTask.actions.add(actionDef)
				
				val eventRef = factory.createViewElementEventRef
				eventRef.setReferencedField(guiElementRef.copy)
				eventRef.setEvent(ElementEventType::ON_CHANGE)
				eventBindingTask.events.add(eventRef)
			}
			
			// add action to controller
			controller.controllerElements.add(customAction)
			
			// add action as call task to startUpAction
			val startupAction = workingInput.resources.map[ r |
				r.allContents.toIterable.filter(typeof(CustomAction))
					.filter( action | action.name.equals(ProcessController::startupActionName))
			].flatten.last
			val callTask = factory.createCallTask
			val actionDef = factory.createActionReference
			actionDef.setActionRef(customAction)
			callTask.setAction(actionDef)
			startupAction.codeFragments.add(0, callTask);
		]
		
	}
	
	//   create setters to bind event and replace the original event binding with the set task
	def private static replaceCustomEventBindingsWithSettersForMappingEntity(
		MD2Factory factory, ResourceSet workingInput,
		Iterable<EventBindingTask> customEventBindings,
		Iterable<EventUnbindTask> customEventUnbindings,
		ContentProvider contentProvider, Entity mappingEntity
	) {
		for (customEventBinding : customEventBindings) {
			val setTask = factory.createAttributeSetTask
			
			val booleanVal = factory.createBooleanVal
			booleanVal.setValue(Boolean::TRUE)
			setTask.setSource(booleanVal)
			
			val mappingPathDefinition = factory.createContentProviderPath
			val pathTail = factory.createPathTail
			pathTail.setAttributeRef(mappingEntity.attributes.filter[ a |
				a.name.equals(customEventBinding.mappingIdentifierHelper)
			].last)
			mappingPathDefinition.setContentProviderRef(contentProvider)
			mappingPathDefinition.setTail(pathTail)
			setTask.setPathDefinition(mappingPathDefinition)
			
			customEventBinding.replace(setTask)
		}
		
		for (customEventUnbinding : customEventUnbindings) {
			val setTask = factory.createAttributeSetTask
			
			val booleanVal = factory.createBooleanVal
			booleanVal.setValue(Boolean::FALSE)
			setTask.setSource(booleanVal)
			
			val mappingPathDefinition = factory.createContentProviderPath
			val pathTail = factory.createPathTail
			pathTail.setAttributeRef(mappingEntity.attributes.filter[ a |
				a.name.equals(customEventUnbinding.mappingIdentifierHelper)
			].last)
			mappingPathDefinition.setContentProviderRef(contentProvider)
			mappingPathDefinition.setTail(pathTail)
			setTask.setPathDefinition(mappingPathDefinition)
			
			customEventUnbinding.replace(setTask)
		}
	}
	
	// remove actual onConditionalEvent
	def private static removeOnConditionalEvents(
		MD2Factory factory, ResourceSet workingInput,
		HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples
	) {
		for (onConditionalEvent : allEventActionTuples.keySet) {
			onConditionalEvent.remove
		}
	}
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Helper methods
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	def private static getMappingIdentifierHelper(EObject binding) {
		val action = switch (binding) {
			EventBindingTask: binding.actions.get(0)
			EventUnbindTask: binding.actions.get(0)
		}
		val event = switch (binding) {
			EventBindingTask: binding.events.last
			EventUnbindTask: binding.events.last
		}
		
		val actionIdentifier = switch (action) {
			SimpleActionRef: "__simple__" + action.action.eClass.name + "_" + action.action.parameterSignature
			ActionReference: action.actionRef.name
		}
		val conditionalEvent = (event as ConditionalEventRef).eventReference
		
		actionIdentifier + "__" + conditionalEvent.name
	}
}
