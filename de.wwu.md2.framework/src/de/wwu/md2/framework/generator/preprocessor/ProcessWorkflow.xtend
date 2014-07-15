package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.MD2ComplexElementFactory
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderPathDefinition
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.GotoWorkflowStepAction
import de.wwu.md2.framework.mD2.LocationProvider
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowGoToNext
import de.wwu.md2.framework.mD2.WorkflowGoToPrevious
import de.wwu.md2.framework.mD2.WorkflowGoToSpecExtended
import de.wwu.md2.framework.mD2.WorkflowGoToStep
import de.wwu.md2.framework.mD2.WorkflowReturn
import de.wwu.md2.framework.mD2.WorkflowStep
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension de.wwu.md2.framework.generator.preprocessor.util.Util.*
import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension org.apache.commons.codec.digest.DigestUtils.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessWorkflow {
	
	////////////////////////////////////////////////
	// Workflow Transformation Methods
	////////////////////////////////////////////////
	
	/**
	 * TODO - documentation + dependencies
	 */
	def static void transformWorkflowsToSequenceOfCoreLanguageElements(MD2ComplexElementFactory factory, ResourceSet workingInput) {
		
		// only run this task if there are workflows present
		val hasWorkflows = workingInput.resources.map[ r |
			r.allContents.toIterable.findFirst( e | e instanceof Workflow)
		].exists(e | e != null)
		
		if (!hasWorkflows) {
			return
		}
		
		val returnStepStack = createReturnStepStack(factory, workingInput)
		
		val controllerStateEntity = createWorkflowControllerStateEntity(factory, workingInput)
		val controllerStateCP = createWorkflowControllerStateContentProvider(factory, workingInput, controllerStateEntity)
		
		val workflowExecuteStepAction = createExecuteStepCustomAction(factory, workingInput, controllerStateEntity, controllerStateCP)
		
		
		val workflowAction = createWorkflowProcessAction(factory, workingInput, controllerStateEntity, controllerStateCP, workflowExecuteStepAction, returnStepStack)
		val eventActionMap = createWorkflowActionTriggerActions(factory, workingInput, controllerStateEntity, controllerStateCP, workflowAction)
		
		registerWorkflowActionTriggerActionsOnStartup(factory, workingInput, eventActionMap)
		removeWorkflows(factory, workingInput)
	}
	
	/**
	 * Create entity that stores the current state of the workflow and populate it with the required attributes
	 * <code>currentWorkflowStep : STRING</code> and <code>lastEventFired : STRING</code>. <code>currentWorkflowStep</code>
	 * stores the current workflow name and stepname in the form <i>workflow__step</i>. <code>lastEventFired</code> always keeps
	 * the name of the last event that was fired (should be the event that triggered the <code>__WorkflowProcessAction</code>).
	 */
	def private static createWorkflowControllerStateEntity(MD2ComplexElementFactory factory, ResourceSet workingInput) {
		val model = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Model))
		].flatten.last
		
		// Create entity
		val stringType = factory.createStringType
		val controllerStateEntity = factory.createComplexEntity(
			"__WorkflowControllerState",
			"currentWorkflowStep" -> stringType,
			"lastEventFired" -> stringType
		)
		
		model.modelElements.add(controllerStateEntity)
		
		return controllerStateEntity
	}
	
	/**
	 * Create content provider for <code>__WorkflowControllerState</code> entity.
	 */
	def private static createWorkflowControllerStateContentProvider(
		MD2ComplexElementFactory factory, ResourceSet workingInput, Entity controllerStateEntity
	) {
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		// Create content provider
		val contentProvider = factory.createComplexContentProvider(
			controllerStateEntity,
			"__workflowControllerStateProvider",
			true,
			false
		)
		
		controller.controllerElements.add(contentProvider)
		
		return contentProvider
	}
	
	/**
	 * TODO - documentation
	 */
	def private static createWorkflowProcessAction(
		MD2ComplexElementFactory factory, ResourceSet workingInput, Entity entity,
		ContentProvider contentProvider, CustomAction workflowExecuteStepAction, HashMap<String, EObject> stack
	) {
		val workflows = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Workflow))
		].flatten
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		// createAction
		val customAction = factory.createCustomAction
		customAction.setName("__workflowProcessingAction")
		controller.controllerElements.add(customAction)
		
		// add conditional code fragment to the custom action
		val conditionalCodeFragment = factory.createConditionalCodeFragment
		customAction.codeFragments.add(conditionalCodeFragment)
		
		// populate conditional code fragment:
		// create if { ...wf1_step1_code... }, elseif { ...wf1_step2_code... }, elseif { ...wf1_stepN_code... }, ..., elseif { ...wfN_stepM_code... }
		workflows.forEach[ workflow, wfIndex |
			val steps = workflow.workflowSteps
			steps.forEach[ step, stepIndex |
				
				///////////////////////////////////////////////////////
				// Outer if...elseif...
				// Decide in which Workflow Step we are
				///////////////////////////////////////////////////////
				
				// Create outer ifCodeBlock with condition
				val outerIfCodeBlock = factory.createIfCodeBlock
				
				{
					val stepStr = step.stringRepresentationOfStep
					val conditionalExpression = factory.createCompareExpression(entity, contentProvider, "currentWorkflowStep", stepStr)
					
					outerIfCodeBlock.setCondition(conditionalExpression)
					
					// add outer ifCodeBlock => first element if(...); all other elements elseif(...)
					if (wfIndex + stepIndex == 0) {
						conditionalCodeFragment.setIf(outerIfCodeBlock)
					} else {
						conditionalCodeFragment.elseifs.add(outerIfCodeBlock)
					}
				}
				
				
				///////////////////////////////////////////////////////
				// Inner if...elseif... for each step-change operation
				// Decide whether the condition for a workflow step
				// change is satisfied and whether the right event
				// was fired.
				///////////////////////////////////////////////////////
				
				val gotos = step.gotos
				
				val innerConditionalCodeFragment = factory.createConditionalCodeFragment
				outerIfCodeBlock.codeFragments.add(innerConditionalCodeFragment)
				
				gotos.forEach[ goto, gotoIndex |
					
					//////////////////////////////////////////////////////////
					// Create inner ifCodeBlock and its according condition
					//////////////////////////////////////////////////////////
					
					val innerIfCodeBlock = factory.createIfCodeBlock
					
					// configure the conditional expression to match all events
					// (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")
					val compareExpressions = goto.spec.events.map[ event |
						factory.createCompareExpression(entity, contentProvider, "lastEventFired", event.stringRepresentationOfEvent)
					]
					val eventsSubCondition = factory.createComplexOr(compareExpressions.iterator)
					
					// add 'given' condition of goto specification (with 'and')
					val given = if (goto.spec instanceof WorkflowGoToSpecExtended && (goto.spec as WorkflowGoToSpecExtended).condition != null) {
						(goto.spec as WorkflowGoToSpecExtended).condition
					}
					
					if (given == null) {
						innerIfCodeBlock.setCondition(eventsSubCondition)
					} else {
						val and = factory.createAnd
						and.leftExpression = eventsSubCondition
						and.rightExpression = given.copy
						innerIfCodeBlock.setCondition(and)
					}
					
					
					//////////////////////////////////////////////////////////
					// Create code fragment for inner if code block
					//////////////////////////////////////////////////////////
					
					val workflowGoTo = goto.goto
					
					// set current workflow step
					{
						val currentWorkflowStepVal = switch(workflowGoTo) {
							// no check for indexOutOfBounds => validator required at programming time
							WorkflowGoToNext: {
								val stringVal = factory.createStringVal
								val targetStep = steps.get(stepIndex + 1).stringRepresentationOfStep
								stringVal.setValue(targetStep)
								stringVal
							}
							WorkflowGoToPrevious: {
								val stringVal = factory.createStringVal
								val targetStep = steps.get(stepIndex - 1).stringRepresentationOfStep
								stringVal.setValue(targetStep)
								stringVal
							}
							WorkflowGoToStep: {
								val stringVal = factory.createStringVal
								val targetStep = workflowGoTo.workflowStep.stringRepresentationOfStep
								stringVal.setValue(targetStep)
								stringVal
							}
							WorkflowReturn: {
								val stackEntity = stack.get("entity") as Entity
								val stackProvider = stack.get("contentProvider") as ContentProvider
								
								val attribute =
									if (workflowGoTo.changeStep && workflowGoTo.changeDirection.equals("proceed")) {
										stackEntity.attributes.findFirst[ a | a.name.equals("returnAndProceedStep")]
									} else if (workflowGoTo.changeStep && workflowGoTo.changeDirection.equals("reverse")) {
										stackEntity.attributes.findFirst[ a | a.name.equals("returnAndReverseStep")]
									} else {
										stackEntity.attributes.findFirst[ a | a.name.equals("returnStep")]
									}
								
								factory.createComplexContentProviderPathDefinition(stackProvider, attribute)
							}
						}
						
						val attributeSetTask = factory.createAttributeSetTask
						val attribute = entity.attributes.findFirst[ a | a.name.equals("currentWorkflowStep")]
						val targetPathDefinition = factory.createComplexContentProviderPathDefinition(contentProvider, attribute)
						attributeSetTask.setPathDefinition(targetPathDefinition)
						
						attributeSetTask.setSource(currentWorkflowStepVal)
						
						innerIfCodeBlock.codeFragments.add(attributeSetTask)
					}
					
					// if this is a 'goto' statement => put current step on stack to allow to return
					if (workflowGoTo instanceof WorkflowGoToStep) {
						val workflowGoToStep = workflowGoTo as WorkflowGoToStep
						
						var currentStep = ""
						var nextStep = ""
						var previousStep = ""
						
						if (workflowGoToStep.returnTo != null) {
							val returnToStep = workflowGoToStep.returnTo
							val returnToStepWorkflow = returnToStep.eContainer as Workflow
							val currentStepIndex = returnToStepWorkflow.workflowSteps.indexOf(returnToStep)
							
							currentStep = returnToStep.stringRepresentationOfStep
							nextStep = 
								if(currentStepIndex + 1 >= returnToStepWorkflow.workflowSteps.size) ""
								else returnToStepWorkflow.workflowSteps.get(stepIndex + 1).stringRepresentationOfStep
							previousStep =
								if(currentStepIndex - 1 < 0) ""
								else returnToStepWorkflow.workflowSteps.get(stepIndex - 1).stringRepresentationOfStep
						} else {
							currentStep = step.stringRepresentationOfStep
							nextStep = if(stepIndex + 1 >= steps.size) "" else steps.get(stepIndex + 1).stringRepresentationOfStep
							previousStep = if(stepIndex - 1 < 0) "" else steps.get(stepIndex - 1).stringRepresentationOfStep
						}
						
						val stackEntity = stack.get("entity") as Entity
						val stackProvider = stack.get("contentProvider") as ContentProvider
								
						val proceedAttribute = stackEntity.attributes.findFirst[ a | a.name.equals("returnAndProceedStep")]
						val reverseAttribute = stackEntity.attributes.findFirst[ a | a.name.equals("returnAndReverseStep")]
						val returnAttribute = stackEntity.attributes.findFirst[ a | a.name.equals("returnStep")]
						
						val proceedAttributePath = factory.createComplexContentProviderPathDefinition(stackProvider, proceedAttribute)
						val reverseAttributePath = factory.createComplexContentProviderPathDefinition(stackProvider, reverseAttribute)
						val returnAttributePath = factory.createComplexContentProviderPathDefinition(stackProvider, returnAttribute)
						
						// add new entity instance to head
						{
							val attributeSetTask = stack.get("addToHeadTask") as AttributeSetTask
							innerIfCodeBlock.codeFragments.add(attributeSetTask)
						}
						
						// set returnAndProceedStep attribute
						{
							val attributeSetTask = factory.createAttributeSetTask
							attributeSetTask.setPathDefinition(proceedAttributePath)
							
							val stringVal = factory.createStringVal
							stringVal.setValue(nextStep)
							attributeSetTask.setSource(stringVal)
							
							innerIfCodeBlock.codeFragments.add(attributeSetTask)
						}
						
						// set returnAndReverseStep attribute
						{
							val attributeSetTask = factory.createAttributeSetTask
							attributeSetTask.setPathDefinition(reverseAttributePath)
							
							val stringVal = factory.createStringVal
							stringVal.setValue(previousStep)
							attributeSetTask.setSource(stringVal)
							
							innerIfCodeBlock.codeFragments.add(attributeSetTask)
						}
						
						// set returnStep attribute
						{
							val attributeSetTask = factory.createAttributeSetTask
							attributeSetTask.setPathDefinition(returnAttributePath)
							
							val stringVal = factory.createStringVal
							stringVal.setValue(currentStep)
							attributeSetTask.setSource(stringVal)
							
							innerIfCodeBlock.codeFragments.add(attributeSetTask)
						}
					}
					
					// if this is a 'return' statement => remove current head step from stack
					if (workflowGoTo instanceof WorkflowReturn) {
						val contentProviderSetTask = stack.get("removeHeadTask") as ContentProviderSetTask
						innerIfCodeBlock.codeFragments.add(contentProviderSetTask)
					}
					
					// create call task for the __workflowExecuteStepAction (that changes the actual view)
					{
						val callTask = factory.createCallTask
						val actionDef = factory.createActionReference
						actionDef.setActionRef(workflowExecuteStepAction)
						callTask.setAction(actionDef)
						innerIfCodeBlock.codeFragments.add(callTask)
					}
					
					// create action to execute after view change ('then' statement)
					if (goto.spec instanceof WorkflowGoToSpecExtended && (goto.spec as WorkflowGoToSpecExtended).action != null) {
						val callTask = factory.createCallTask
						val actionDef = (goto.spec as WorkflowGoToSpecExtended).action
						callTask.setAction(actionDef.copy)
						innerIfCodeBlock.codeFragments.add(callTask)
					}
					
					
					///////////////////////////////////////////////////////////////////////////////////
					// add inner ifCodeBlock => first element if(...); all other elements elseif(...)
					///////////////////////////////////////////////////////////////////////////////////
					
					if (gotoIndex == 0) {
						innerConditionalCodeFragment.setIf(innerIfCodeBlock)
					} else {
						innerConditionalCodeFragment.elseifs.add(innerIfCodeBlock)
					}
				]
				
				// if message is defined:
				// add a final elseif that catches the event if none of the other conditions was satisfied
				// ... elseif (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtX")
				// for all events of the defined gotos
				if (gotos.size > 0 && !step.message.nullOrEmpty) {
					val events = gotos.map[ g |
						g.spec.events.map(e | e.stringRepresentationOfEvent)
					].flatten.toSet
					
					// build the conditional expression to match all events
					val compareExpressions = events.map[ eventStr |
						factory.createCompareExpression(entity, contentProvider, "lastEventFired", eventStr)
					]
					val condition = factory.createComplexOr(compareExpressions.iterator)
					
					val ifCodeBlock = factory.createIfCodeBlock
					ifCodeBlock.setCondition(condition)
					innerConditionalCodeFragment.elseifs.add(ifCodeBlock)
				}
			]
		]
		
		return customAction
	}
	
	/**
	 * For each event create an action that sets the name of the event to the <i>lastEventFired</i> attribute and call the actual
	 * workflow processing action. These actions are then bound to the according events. This can be seen as a workaround, because
	 * in MD2 there is no way to find out which event triggered a particular action.
	 */
	def private static createWorkflowActionTriggerActions(
		MD2Factory factory, ResourceSet workingInput, Entity entity, ContentProvider contentProvider, CustomAction workflowAction
	) {
		
		val workflows = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Workflow))
		].flatten
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		// get all events of all workflows
		val gotos = workflows.map(wf | wf.workflowSteps).flatten.map(step | step.gotos).flatten
		val eventMap = newHashMap
		gotos.map(g | g.spec.events).flatten.forEach[ event |
			eventMap.put(event.stringRepresentationOfEvent, event)
		]
		
		// create actions and store them in a map of (event->action) pairs
		val eventActionMap = newHashMap
		eventMap.forEach[ str, event |
			val customAction = factory.createCustomAction
			customAction.setName("__workflowActionEventTrigger_" + str.sha1Hex)
			
			// set task
			val setTask = factory.createAttributeSetTask
			customAction.codeFragments.add(setTask)
			
			val stringVal = factory.createStringVal
			stringVal.setValue(str)
			setTask.setSource(stringVal)
			
			val pathDefinition = factory.createContentProviderPathDefinition
			val pathTail = factory.createPathTail
			pathTail.setAttributeRef(entity.attributes.filter[ a |
				a.name.equals("lastEventFired")
			].last)
			pathDefinition.setContentProviderRef(contentProvider)
			pathDefinition.setTail(pathTail)
			setTask.setPathDefinition(pathDefinition)
			
			// call task
			val callTask = factory.createCallTask
			val actionDef = factory.createActionReference
			actionDef.setActionRef(workflowAction)
			callTask.setAction(actionDef)
			customAction.codeFragments.add(callTask)
			
			controller.controllerElements.add(customAction)
			eventActionMap.put(event, customAction)
		]
		
		return eventActionMap
	}
	
	def private static void registerWorkflowActionTriggerActionsOnStartup(
		MD2Factory factory, ResourceSet workingInput, HashMap<EventDef, CustomAction> eventActionMap
	) {
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		// create custom action to register all events
		val customAction = factory.createCustomAction
		customAction.setName("__registerWorkflowActionEventTrigger")
		controller.controllerElements.add(customAction)
		
		// for each event create event binding task
		eventActionMap.forEach[ event, action |
			val eventBindingTask = factory.createEventBindingTask
			customAction.codeFragments.add(eventBindingTask)
			
			val actionDef = factory.createActionReference
			actionDef.setActionRef(action)
			
			eventBindingTask.actions.add(actionDef)
			eventBindingTask.events.add(event.copy)
		]
		
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
	}
	
	def static createReturnStepStack(MD2ComplexElementFactory factory, ResourceSet workingInput) {
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		val model = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Model))
		].flatten.last
		
		val stringType = factory.createStringType
		val stack = factory.createComplexStack(
			"__ReturnStepStack",
			"returnStep" -> stringType,
			"returnAndReverseStep" -> stringType,
			"returnAndProceedStep" -> stringType
		)
		
		controller.controllerElements.add(stack.get("contentProvider") as ContentProvider)
		model.modelElements.add(stack.get("entity") as Entity)
		
		return stack
	}
	
	def static createExecuteStepCustomAction(
		MD2ComplexElementFactory factory, ResourceSet workingInput, Entity entity,
		ContentProvider contentProvider
	) {
		
		val workflowSteps = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Workflow)).map[ w |
				w.workflowSteps
			].flatten
		].flatten
		
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		
		val customAction = factory.createCustomAction
		customAction.setName("__workflowExecuteStepAction")
		controller.controllerElements.add(customAction)
		
		val conditionalCodeFragment = factory.createConditionalCodeFragment
		customAction.codeFragments.add(conditionalCodeFragment)
		
		workflowSteps.forEach[ step, index |
			val stepStr = step.stringRepresentationOfStep
			val conditionalExpression = factory.createCompareExpression(entity, contentProvider, "currentWorkflowStep", stepStr)
			
			val ifCodeBlock = factory.createIfCodeBlock
			ifCodeBlock.setCondition(conditionalExpression)
			
			// create and add GotoViewAction for current step
			{
				val callTask = factory.createCallTask
				val simpleActionRef = factory.createSimpleActionRef
				val gotoViewAction = factory.createGotoViewAction
				callTask.setAction(simpleActionRef)
				simpleActionRef.setAction(gotoViewAction)
				gotoViewAction.setView(step.view)
				ifCodeBlock.codeFragments.add(callTask)
			}
			
			// add outer ifCodeBlock => first element if(...); all other elements elseif(...)
			if (index == 0) {
				conditionalCodeFragment.setIf(ifCodeBlock)
			} else {
				conditionalCodeFragment.elseifs.add(ifCodeBlock)
			}
		]
		
		return customAction
	}
	
	def static void removeWorkflows(MD2Factory factory, ResourceSet workingInput) {
		val workflows = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Workflow))
		].flatten
		
//		while (!workflows.empty) {
//			workflows.last.remove
//		}
	}
	
	
	////////////////////////////////////////////////
	// Workflow Actions
	////////////////////////////////////////////////
	
	def static void transformNextStepActionToCustomActionCall(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	def static void transformPreviousStepActionToCustomActionCall(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	def static void transformGotoStepActionToCustomActionCall(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	def static void transformSetWorkflowActionToCustomActionCall(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	
	////////////////////////////////////////////////
	// Helper methods
	////////////////////////////////////////////////
	
	/**
	 * Helper to create a non-ambiguous string representation for events.
	 */
	def private static getStringRepresentationOfEvent(EventDef event) {
		switch (event) {
			ViewElementEventRef: {
				var EObject eObject = event.referencedField.ref
				var str = ""
				while (!(eObject instanceof View)) {
					if(eObject instanceof ViewGUIElement) {
						str = "." + (eObject as ViewGUIElement).name + str
					}
					eObject = eObject.eContainer
				}
				"__gui" + str + "." + event.event.toString
			}
			ContentProviderEventRef: switch (event) {
				ContentProviderPathDefinition: "__contentProvider." + event.contentProviderRef + "." + event.tail.pathTailAsString + "." + event.event.toString
				LocationProvider: "__contentProvider.location." + event.locationField.toString
			}
			GlobalEventRef: "__global." + event.event.toString
			ConditionalEventRef: "__conditional." + event.eventReference.name
		}
	}
	
	/**
	 * Helper to create the string representation of a workflow step name of the form <i>workflowName__stepName</i>.
	 */
	def private static getStringRepresentationOfStep(WorkflowStep step) {
		val workflow = step.eContainer as Workflow
		return workflow.name + "__" + step.name
	}
	
	/**
	 * Helper to build a conditional expression of the form <code>contentProvider.attributeName equals "compareWith"</code>.
	 */
	def private static createCompareExpression(
		MD2ComplexElementFactory factory, Entity entity, ContentProvider contentProvider, String attributeName, String compareWith
	) {
		
		// eqLeft composition
		val attribute = entity.attributes.findFirst[ a | a.name.equals(attributeName)]
		val contentProviderPathDefinition = factory.createComplexContentProviderPathDefinition(contentProvider, attribute)
		
		// op composition
		val operator = Operator::EQUALS
		
		// eqRight composition
		val stringVal = factory.createStringVal
		stringVal.setValue(compareWith)
		
		// build expression
		val conditionalExpression = factory.createCompareExpression
		conditionalExpression.setEqLeft(contentProviderPathDefinition)
		conditionalExpression.setOp(operator)
		conditionalExpression.setEqRight(stringVal)
		
		return conditionalExpression
	}
	
	
	
	////////////////////////////////////////////////
	// Subworkflow merging
	// 
	// TODO Legacy code. Not reviewed again =>
	//      Reconsider whether subworkflows are
	//      necessary!
	////////////////////////////////////////////////
	
	/**
	 * Merge nested workflows.
	 */
	def static void mergeNestedWorkflows(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<Workflow> workflows = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(Workflow))).flatten
		val Iterable<GotoWorkflowStepAction> gotoWfStepAction = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(GotoWorkflowStepAction))).flatten
		for (workflow : workflows) {
			workflow.processWorkflowMerging(gotoWfStepAction, factory)
		}
	}
	
	def private static Workflow processWorkflowMerging(Workflow workflow, Iterable<GotoWorkflowStepAction> gotoWfStepAction, MD2Factory factory) {
		// copy actual wf step list to avoid ConcurrentModificationException...
		val workflowStepsCopy = <WorkflowStep>newArrayList
		workflowStepsCopy.addAll(workflow.workflowSteps)
		
		// collect steps to remove
		val stepsToRemove = <WorkflowStep>newHashSet
		
		// ...but operate on original wf step list
		for(step : workflowStepsCopy) {
			if(step.subworkflow != null) {
				// replace workflow step with actual subworkflow
				val idx = workflow.workflowSteps.indexOf(step)
				var i = 0
				for(subStep : step.subworkflow.processWorkflowMerging(gotoWfStepAction, factory).workflowSteps) {
					val copiedSubStep = subStep.copyElement as WorkflowStep
					copiedSubStep.setName(step.name + "_" + copiedSubStep.name)
					workflow.workflowSteps.add(idx + i, copiedSubStep)
					i = i + 1
				}
				
				// replace all references to this step with the first step of the subworkflow
				// and remove current wf step
				for (action : gotoWfStepAction.filter(a | a.wfStep.equals(step))) {
					if(step.subworkflow.workflowSteps.size > 0) {
						action.setWfStep(workflow.workflowSteps.get(idx))
					}
				}
				stepsToRemove.add(step)
				
				
				// Duplicate Workflow.gotoToStepAction so that it references to all sub workflows
				for (action : gotoWfStepAction.filter(a | a.wfStep.eContainer.equals(step.subworkflow))) {
					// build new action
					val newGotoWfStepAction = factory.createGotoWorkflowStepAction
					newGotoWfStepAction.setWfStep(workflow.workflowSteps.filter(s | s.name.equals(step.name + "_" + action.wfStep.name)).last)
					val newSimpleActionRef = factory.createSimpleActionRef
					newSimpleActionRef.setAction(newGotoWfStepAction)
					
					// add new action for duplicated Wf step
					val actionContainer = action.eContainer.eContainer
					switch (actionContainer) {
						EventBindingTask: actionContainer.actions.add(newSimpleActionRef)
						EventUnbindTask: actionContainer.actions.add(newSimpleActionRef)
						CallTask: {
							val customAction = actionContainer.eContainer as CustomAction
							val newCallTask = factory.createCallTask
							newCallTask.setAction(newSimpleActionRef)
							customAction.codeFragments.add(customAction.codeFragments.indexOf(actionContainer), newCallTask)
						}
					}
				}
			}
		}
		
		workflow.workflowSteps.removeAll(stepsToRemove)
		workflow
	}
}
