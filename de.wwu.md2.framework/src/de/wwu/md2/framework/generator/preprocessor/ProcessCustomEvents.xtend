package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.AbstractContentProviderPath
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.Boolean
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventType
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomCodeFragment
import de.wwu.md2.framework.mD2.ElementEventType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.OnConditionEvent
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.SimpleActionRef
import java.util.HashMap

import static extension de.wwu.md2.framework.generator.preprocessor.util.Helper.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*import de.wwu.md2.framework.mD2.WorkflowElement

/**
 * Transforms all OnConditionEvents to core language elements (Entities, ContentProviders, OnChangeEvents, CustomActions).
 */
class ProcessCustomEvents extends AbstractPreprocessor {
	
	/**
	 * <p>Transforms all OnConditionEvents to core language elements (Entities, ContentProviders, OnChangeEvents, CustomActions). This
	 * is the main step that is further split into substeps.</p>
	 * 
	 * <p>Idea: For each conditional event binding task (e.g. <code>bind action myAction on myConditionEvent</code>), an attribute with the name
	 * <i>myAction__myConditionEvent</i> is created and added to the <i>__ConditionalEventMappings</i> entity. The data type of this attribute
	 * is boolean. All event mappings are now replaced by setter tasks that set the attribute value to true, unmapping tasks are replaced by setter
	 * tasks that set the attribute value to false.</p>
	 * 
	 * <p>Furthermore, a CustomAction is created that contains one if-block with the condition of the actual conditional event. If the condition is
	 * satisfied, in an inner if-block for each mapping it is checked whether the mapping flag is set to true. The code block of the inner if-conditions
	 * contains a call task that calls the action <i>myAction</i> to which the event was actually bound. For each contentProvider attribute and each
	 * guiElement that is referenced in the condition an EventBindingTask is created that binds the newly created CustomAction to the respective
	 * <code>onChange</code> event.</p>
	 * 
	 * <p>Example:</p>
	 * <pre>
	 * event OnConditionEvent myEvent {
	 *   :anyProvider.attribute1 equals "anyString" and myView.numberInput >= 8
	 * }
	 * 
	 * action CustomAction myOtherAction {
	 *   bind myAction on myEvent
	 * }
	 * 
	 * action CustomAction myAction {
	 *   // Do something if myEvent is triggered
	 * }
	 * </pre>
	 * 
	 * is transformed into the following MD2 code:
	 * <pre>
	 * contentProvider __ConditionalEventMappings __conditionalEventMappingsProvider {
	 *   type local
	 * }
	 * action CustomAction __conditionalEvent_myEvent {
	 *   if (:anyProvider.attribute1 equals "anyString" and myView.numberInput >= 8) {
	 *     if (:__conditionalEventMappingsProvider.myOtherAction__myEvent equals true) {
	 *       call myAction
	 *     }
	 *     // further else ifs for other action-custom event mappings
	 *   }
	 * }
	 * action CustomAction __startupAction {
	 *   bind __conditionalEvent_myEvent on :anyProvider.attribute1.onChange
	 *   bind __conditionalEvent_myEvent on myView.numberInput.onChange
	 * }
	 * action CustomAction myOtherAction {
	 *   set :__conditionalEventMappingsProvider.myOtherAction__myEvent = true
	 * }
	 * action CustomAction myAction {
	 *   // Do something if myEvent is triggered
	 * }
	 * </pre>
	 * <pre>
	 * entity __ConditionalEventMappings {
	 *   myOtherAction__myEvent: boolean
	 * }
	 * </pre>
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - It is assumed that a __startUp action exists in which all new event bindings
	 *     can be placed.
	 *   </li>
	 *   <li>
	 *     <i>transformWorkflowsToSequenceOfCoreLanguageElements</i> - The workflow definition may contain conditional events. These events that are
	 *     defined in the workflow steps are transformed into normal EventBindingTasks during the workflow processing. Only these EventBindingTasks
	 *     can be handled by this transformation step.
	 *   </li>
	 *   <li>
	 *     <i>transformEventBindingAndUnbindingTasksToOneToOneRelations</i> - This step relies on the aspect that each mapping consists of exactly
	 *     one activity and one event (using .head without checking the size of each events/actions list).
	 *   </li>
	 *   <li>
	 *     <i>calculateParameterSignatureForAllSimpleActions</i> - Required to create identifiers for each simple action.
	 *   </li>
	 * </ul>
	 */
	def transformAllCustomEventsToBasicLanguageStructures(WorkflowElement wfe) {
		
		val hasConditionalEvents = wfe.eAllContents.exists(e| e instanceof OnConditionEvent)
		
		// only run this task if there are conditional events present
		if (!hasConditionalEvents) {
			return
		}
		
		// get all event binding and event unbinding tasks that refer to custom events
		val customEventBindings = wfe.customEventBindings
		val customEventUnbindings = wfe.customEventUnbindings
		
		
		//////////////////////////////////////
		// Sub-Steps
		//////////////////////////////////////
		
		val allEventActionTuples = createAllEventActionTuples(customEventBindings, customEventUnbindings)
		val mappingEntity        = createEntity(allEventActionTuples)
		val contentProvider      = createContentProviderForEntity(mappingEntity)

		createCustomActionForEachConditionalEvent(allEventActionTuples, contentProvider, mappingEntity, wfe)
		createCustomActionToRegisterConditionalEvents(allEventActionTuples, wfe)
		replaceCustomEventBindingsWithSettersForMappingEntity(customEventBindings, customEventUnbindings, contentProvider, mappingEntity)
		removeOnConditionalEvents(allEventActionTuples)

	}
	
	/**
	 * Generate string identifiers for each event->action mapping and store them in a nested HashMap of the form
	 * (event => [identifier => action]) that is used in later steps to get all actions that are mapped to a certain event.
	 * The string identifiers assure that each event->action mapping is only stored once (it is not relevant whether a mapping
	 * is a binding or an unbinding task as only one attribute will be created per binding => true/false indicates whether the
	 * actual task is bound).
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
	private def createAllEventActionTuples(
		Iterable<EventBindingTask> customEventBindings, Iterable<EventUnbindTask> customEventUnbindings
	) {
		
		val allEventActionTuples = newHashMap
		
		customEventBindings.forEach[ binding |
			val action = binding.actions.get(0)
			val conditionalEvent = (binding.events.last as ConditionalEventRef).eventReference
			
			if(allEventActionTuples.get(conditionalEvent) == null) {
				allEventActionTuples.put(conditionalEvent, newHashMap)
			}
			
			allEventActionTuples.get(conditionalEvent).put(binding.mappingIdentifier, action)
		]
		
		customEventUnbindings.forEach[ binding |
			val action = binding.actions.get(0)
			val conditionalEvent = (binding.events.last as ConditionalEventRef).eventReference
			
			if(allEventActionTuples.get(conditionalEvent) == null) {
				allEventActionTuples.put(conditionalEvent, newHashMap)
			}
			
			allEventActionTuples.get(conditionalEvent).put(binding.mappingIdentifier, action)
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
	private def createEntity(HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples) {
		
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
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	private def createContentProviderForEntity(Entity mappingEntity) {
		
		val referencedModelType = factory.createReferencedModelType
		referencedModelType.setEntity(mappingEntity)
		
		val contentProvider = factory.createContentProvider
		contentProvider.setName("__conditionalEventMappingsProvider")
		contentProvider.setLocal(true)
		contentProvider.setType(referencedModelType)
		
		controller.controllerElements.add(contentProvider)
		
		return contentProvider
	}
	
	/**
	 * For each OnConditionEvent: Create a CustomAction that contains one if-block with the condition of the actual conditional event. If the condition is
	 * satisfied, in an inner if-block for each mapping it is checked whether the mapping flag is set to true. The code block of the inner if-conditions
	 * contains a call task that calls the action <i>myAction</i> to which the event was actually bound.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	private def createCustomActionForEachConditionalEvent(
		HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples, ContentProvider contentProvider,
		Entity mappingEntity, WorkflowElement wfe
	) {
		
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
					pathTail.setAttributeRef(mappingEntity.attributes.filter( a | a.name.equals(identifier)).head)
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
			
			wfe.actions.add(customAction)
		]
	}
	
	/**
	 * For each CustomEvent: create __registerCustomEventName action and add it to startUpAction.
	 * This is just to structure the code. All the event bindings could also be placed directly in the
	 * startup action or in one single custom action.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - It is assumed that a __startUp action exists in
	 *     which all new event bindings can be placed.
	 *   </li>
	 * </ul>
	 */
	private def createCustomActionToRegisterConditionalEvents(
		HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples, WorkflowElement wfe
	) {
		
		//val controller = controllers.head
		
		allEventActionTuples.forEach[ event, map |
			val customAction = factory.createCustomAction
			customAction.setName("__conditionalEventRegister_" + event.name)
			
			// Stores representations of all events already added to avoid duplicates
			val avoidDuplicates = newHashSet
			
			// get all contentProviderPathes from event.condition
			val pathDefinitions = event.condition.eAllContents.toIterable.filter(AbstractContentProviderPath)
			for (pathDefinition : pathDefinitions) {
				val eventBindingTask = factory.createEventBindingTask
				
				val actionDef = factory.createActionReference
				val action = wfe.eAllContents.filter(CustomAction).filter(a | a.name.equals("__conditionalEvent_" + event.name)).head
				actionDef.setActionRef(action)
				eventBindingTask.actions.add(actionDef)
				
				val eventRef = factory.createContentProviderPathEventRef
				eventRef.setPathDefinition(pathDefinition.copy)
				eventRef.setEvent(ContentProviderEventType::ON_CHANGE)
				eventBindingTask.events.add(eventRef)
				
				val stringRepresentation = eventRef.stringRepresentationOfEvent
				if (!avoidDuplicates.contains(stringRepresentation)) {
					customAction.codeFragments.add(eventBindingTask)
					avoidDuplicates.add(stringRepresentation)
				}
			}
			
			// get all GUIElement references from event.condition
			val guiElementRefs = event.condition.eAllContents.toIterable.filter(AbstractViewGUIElementRef)
			for (guiElementRef : guiElementRefs) {
				val eventBindingTask = factory.createEventBindingTask
				
				val actionDef = factory.createActionReference
				val action = wfe.eAllContents.filter(CustomAction).filter(a | a.name.equals("__conditionalEvent_" + event.name)).head
				actionDef.setActionRef(action)
				eventBindingTask.actions.add(actionDef)
				
				val eventRef = factory.createViewElementEventRef
				eventRef.setReferencedField(guiElementRef.copy)
				eventRef.setEvent(ElementEventType::ON_CHANGE)
				eventBindingTask.events.add(eventRef)
				
				val stringRepresentation = eventRef.stringRepresentationOfEvent
				if (!avoidDuplicates.contains(stringRepresentation)) {
					customAction.codeFragments.add(eventBindingTask)
					avoidDuplicates.add(stringRepresentation)
				}
			}
			
			// add action to controller
			wfe.actions.add(customAction)
			
			// add action as call task to startUpAction
			val initAction = wfe.initActions.filter(CustomAction).head
			
			//TODO: code fragment in comment can be totally removed when DSL is changed 
			//-> we probably only need one initAction per workflow element
			//val startupAction = wfe.eAllContents.filter(CustomAction)
			//		.filter( action | action.name.equals(ProcessController::startupActionName))
			
			val callTask = factory.createCallTask
			val actionDef = factory.createActionReference
			actionDef.setActionRef(customAction)
			callTask.setAction(actionDef)
			initAction.codeFragments.add(0, callTask);
		]
		
	}
	
	/**
	 * Create setters to bind the event (set mapping flag in content provider to <code>true</code>) and replace the original
	 * event binding with the AttributeSetTask.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>transformEventBindingAndUnbindingTasksToOneToOneRelations</i> - This step relies on the aspect that each mapping consists of exactly
	 *     one activity and one event (using .head without checking the size of each events/actions list).
	 *   </li>
	 * </ul>
	 */
	private def replaceCustomEventBindingsWithSettersForMappingEntity(
		Iterable<EventBindingTask> customEventBindings, Iterable<EventUnbindTask> customEventUnbindings,
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
				a.name.equals(customEventBinding.mappingIdentifier)
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
				a.name.equals(customEventUnbinding.mappingIdentifier)
			].last)
			mappingPathDefinition.setContentProviderRef(contentProvider)
			mappingPathDefinition.setTail(pathTail)
			setTask.setPathDefinition(mappingPathDefinition)
			
			customEventUnbinding.replace(setTask)
		}
	}
	
	/**
	 * Cleanup: Remove actual OnConditionEvent after everything was transformed.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	private def removeOnConditionalEvents(HashMap<OnConditionEvent, HashMap<String, ActionDef>> allEventActionTuples) {
		for (onConditionEvent : allEventActionTuples.keySet) {
			onConditionEvent.remove
		}
	}
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Helper methods
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Create a unique string identifier for each CustomAction-ConditionalEvent mapping. This string is used
	 * as the attribute name in the mapping entity.
	 */
	private def getMappingIdentifier(CustomCodeFragment binding) {
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
	
	/**
	 * Helper method that returns an iterable with all EventBindingTasks whose eventType refers to an
	 * OnConditionEvent.
	 */
	private def getCustomEventBindings(WorkflowElement wfe) {
		wfe.eAllContents.toIterable
				.filter(EventBindingTask)
				.filter(bindingTask | bindingTask.events.exists(eventType | eventType instanceof ConditionalEventRef))
	}
	
	/**
	 * Helper method that returns an iterable with all EventUnbindingTasks whose eventType refers to an
	 * OnConditionEvent.
	 */
	private def getCustomEventUnbindings(WorkflowElement wfe){
		wfe.eAllContents.toIterable
				.filter(EventUnbindTask)
				.filter(unbindingTask | unbindingTask.events.exists(eventType | eventType instanceof ConditionalEventRef))
	}
}
