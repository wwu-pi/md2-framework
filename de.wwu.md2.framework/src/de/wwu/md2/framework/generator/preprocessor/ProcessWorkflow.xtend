package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.Boolean
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.ContentProviderPathEventRef
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.LocationProviderPath
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.SetWorkflowAction
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ViewGUIElement
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowGoToDefinition
import de.wwu.md2.framework.mD2.WorkflowGoToNext
import de.wwu.md2.framework.mD2.WorkflowGoToPrevious
import de.wwu.md2.framework.mD2.WorkflowGoToSpecExtended
import de.wwu.md2.framework.mD2.WorkflowGoToStep
import de.wwu.md2.framework.mD2.WorkflowGotoAction
import de.wwu.md2.framework.mD2.WorkflowProceedAction
import de.wwu.md2.framework.mD2.WorkflowReturn
import de.wwu.md2.framework.mD2.WorkflowReverseAction
import de.wwu.md2.framework.mD2.WorkflowStep
import java.util.Collection
import java.util.HashMap
import org.eclipse.emf.ecore.EObject

import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static extension org.apache.commons.codec.digest.DigestUtils.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessWorkflow extends AbstractPreprocessor {
	
	////////////////////////////////////////////////
	// Workflow Transformation Methods
	////////////////////////////////////////////////
	
	/**
	 * TODO - documentation + dependencies
	 */
	def transformWorkflowsToSequenceOfCoreLanguageElements() {
		
		// only run this task if there are workflows present
		val hasWorkflows = workingInput.resources.map[ r |
			r.allContents.toIterable.findFirst( e | e instanceof Workflow)
		].exists(e | e != null)
		
		if (!hasWorkflows) {
			return
		}
		
		val returnStepStack = createReturnStepStack
		
		val controllerStateEntity = createWorkflowControllerStateEntity
		val controllerStateCP = createWorkflowControllerStateContentProvider(controllerStateEntity)
		
		val workflowExecuteStepAction = createExecuteStepCustomAction(controllerStateEntity, controllerStateCP)
		
		
		val workflowAction = createWorkflowProcessAction(controllerStateEntity, controllerStateCP, workflowExecuteStepAction, returnStepStack)
		val eventActionMap = createWorkflowActionTriggerActions(controllerStateEntity, controllerStateCP, workflowAction)
		
		registerWorkflowActionTriggerActionsOnStartup(eventActionMap)
		
		// Transform all SimpleActions for the workflow control
		transformSetWorkflowActionToCustomActionCall(controllerStateEntity, controllerStateCP, workflowExecuteStepAction)
		transformWorkflowProceedActionToCustomActionCall(controllerStateEntity, controllerStateCP, workflowExecuteStepAction)
		transformWorkflowReverseActionToCustomActionCall(controllerStateEntity, controllerStateCP, workflowExecuteStepAction)
		transformWorkflowGotoActionToCustomActionCall(controllerStateEntity, controllerStateCP, workflowExecuteStepAction)
		
		// Remove actual workflow after everything has been transformed
		removeWorkflows
	}
	
	/**
	 * Create entity that stores the current state of the workflow and populate it with the required attributes
	 * <code>currentWorkflowStep : STRING</code> and <code>lastEventFired : STRING</code>. <code>currentWorkflowStep</code>
	 * stores the current workflow name and stepname in the form <i>workflow__step</i>. <code>lastEventFired</code> always keeps
	 * the name of the last event that was fired (should be the event that triggered the <code>__WorkflowProcessAction</code>).
	 */
	private def createWorkflowControllerStateEntity() {
		val model = models.last
		
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
	private def createWorkflowControllerStateContentProvider(Entity controllerStateEntity) {
		val controller = controllers.last
		
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
	private def createWorkflowProcessAction(
		Entity entity, ContentProvider contentProvider, CustomAction workflowExecuteStepAction, HashMap<String, EObject> stack
	) {
		val workflows = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Workflow)
		].flatten
		
		val controller = controllers.last
		
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
					val conditionalExpression = createCompareExpression(entity, contentProvider, "currentWorkflowStep", stepStr)
					
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
				if (!gotos.empty) {
					outerIfCodeBlock.codeFragments.add(innerConditionalCodeFragment)
				}
				
				gotos.forEach[ goto, gotoIndex |
					
					val workflowGoTo = goto.goto
					
					//////////////////////////////////////////////////////////
					// Create inner ifCodeBlock and its according condition
					//////////////////////////////////////////////////////////
					
					val innerIfCodeBlock = factory.createIfCodeBlock
					
					// configure the conditional expression to match all events and the WorkflowProceed,
					// WorkflowReverse and WorkflowGoto simple action calls
					// (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")
					val eventsSubCondition = matchAllEventsCondition(newHashSet(goto), entity, contentProvider)
					
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
				if (gotos.size > 0 && step.message != null) {
					val ifCodeBlock = factory.createIfCodeBlock
					val condition = matchAllEventsCondition(gotos, entity, contentProvider)
					ifCodeBlock.setCondition(condition)
					innerConditionalCodeFragment.elseifs.add(ifCodeBlock)
					
					// Create DisplayMessageAction and add it to the elseif block
					{
						val callTask = factory.createCallTask
						val actionDef = factory.createSimpleActionRef
						val displayMessageAction = factory.createDisplayMessageAction
						displayMessageAction.setMessage(step.message)
						actionDef.setAction(displayMessageAction)
						callTask.setAction(actionDef)
						ifCodeBlock.codeFragments.add(callTask)
					}
				}
			]
		]
		
		return customAction
	}
	
	/**
	 * For each event create an action that sets the name of the event to the <i>lastEventFired</i> attribute and calls the actual
	 * workflow processing action. These actions are then bound to the according events. This can be seen as a workaround, because
	 * in MD2 there is no way to find out which event triggered a particular action.
	 */
	private def createWorkflowActionTriggerActions(Entity entity, ContentProvider contentProvider, CustomAction workflowAction) {
		
		val workflows = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Workflow)
		].flatten
		
		val controller = controllers.last
		
		// get all events of all workflows
		val gotos = workflows.map(wf | wf.workflowSteps).flatten.map(step | step.gotos).flatten
		val eventMap = newHashMap
		gotos.map(g | g.spec.events).flatten.forEach[ event |
			eventMap.put(event.stringRepresentationOfEvent, event)
		]
		
		// create actions and store them in a map of (event->action) pairs
		val eventActionMap = newHashMap
		eventMap.forEach[ str, event |
			
			val customAction = buildWorkflowActionTriggerAction(
				"__workflowActionEventTrigger_" + str.sha1Hex, str, entity, contentProvider, workflowAction
			)
			
			controller.controllerElements.add(customAction)
			eventActionMap.put(event, customAction)
		]
		
		return eventActionMap
	}
	
	private def registerWorkflowActionTriggerActionsOnStartup(HashMap<EventDef, CustomAction> eventActionMap) {
		
		val controller = controllers.last
		
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
		val startupAction = controllers.map[ ctrl |
			ctrl.controllerElements.filter(CustomAction)
				.filter( action | action.name.equals(ProcessController::startupActionName))
		].flatten.last
		val callTask = factory.createCallTask
		val actionDef = factory.createActionReference
		actionDef.setActionRef(customAction)
		callTask.setAction(actionDef)
		startupAction.codeFragments.add(0, callTask);
	}
	
	private def createReturnStepStack() {
		
		val controller = controllers.last
		val model = models.last
		
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
	
	private def createExecuteStepCustomAction(Entity entity, ContentProvider contentProvider) {
		
		val workflowSteps = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Workflow).map[ w |
				w.workflowSteps
			].flatten
		].flatten
		
		val controller = controllers.last
		
		val customAction = factory.createCustomAction
		customAction.setName("__workflowExecuteStepAction")
		controller.controllerElements.add(customAction)
		
		val conditionalCodeFragment = factory.createConditionalCodeFragment
		if (!workflowSteps.empty) {
			customAction.codeFragments.add(conditionalCodeFragment)
		}
		
		workflowSteps.forEach[ step, index |
			val stepStr = step.stringRepresentationOfStep
			val conditionalExpression = createCompareExpression(entity, contentProvider, "currentWorkflowStep", stepStr)
			
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
	
	private def removeWorkflows() {
		val workflows = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Workflow)
		].flatten
		
		while (!workflows.empty) {
			workflows.last.remove
		}
	}
	
	
	////////////////////////////////////////////////
	// Workflow Actions
	////////////////////////////////////////////////
	
	/**
	 * Replace the SetWorkflowAction with a CustomAction action that sets the current workflow step in the
	 * <code>__workflowControllerStateProvider</code> to the first step of the specified workflow and then executes
	 * the <code>__workflowExecuteStepAction</code> to go to the actual view.
	 * 
	 * First custom actions that set and go to the respective workflow are created for all SetWorkflowActions, then
	 * in a second step all SetWorkflowActions are replaced with the newly created custom actions.
	 */
	private def transformSetWorkflowActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction workflowExecuteStepAction
	) {
		
		// get random controller element to place the action in
		val controller = controllers.last
		
		// get all SetWorkflowActions
		val setWorkflowActions = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(SetWorkflowAction)
		].flatten
		
		// remember all SetWorkflow###Actions that are already created, so that for each workflow only one such
		// action is created
		val createdSetWorkflowActions = newHashMap
		
		// Step 1:
		// Create custom actions for all SetWorkflowActions that set the new workflow step in the
		// content provider and then call the __workflowExecuteStepAction.
		setWorkflowActions.forEach[ setWorkflowAction |
			
			val workflow = setWorkflowAction.workflow
			
			if (!createdSetWorkflowActions.containsKey(workflow)) {
				
				val customAction = factory.createCustomAction
				customAction.setName("__workflowSetWorkflow" + workflow.name.toFirstUpper + "Action")
				controller.controllerElements.add(customAction)
				createdSetWorkflowActions.put(workflow, customAction)
				
				// create attribute set task
				{
					val stringVal = factory.createStringVal
					val targetStep = workflow.workflowSteps.head.stringRepresentationOfStep
					stringVal.setValue(targetStep)
					
					val attributeSetTask = factory.createAttributeSetTask
					val attribute = entity.attributes.findFirst[ a | a.name.equals("currentWorkflowStep")]
					val targetPathDefinition = factory.createComplexContentProviderPathDefinition(contentProvider, attribute)
					attributeSetTask.setPathDefinition(targetPathDefinition)
					
					attributeSetTask.setSource(stringVal)
					
					customAction.codeFragments.add(attributeSetTask)
				}
				
				// create call task for the __workflowExecuteStepAction (that changes the actual view)
				{
					val callTask = factory.createCallTask
					val actionDef = factory.createActionReference
					actionDef.setActionRef(workflowExecuteStepAction)
					callTask.setAction(actionDef)
					customAction.codeFragments.add(callTask)
				}
			}
		]
		
		// Step2:
		// Replace all SetWorkflowActions with the newly created custom actions.
		setWorkflowActions.forEach[ setWorkflowAction |
			
			val workflow = setWorkflowAction.workflow
			val containingActionDef = setWorkflowAction.eContainer as ActionDef
			
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			val customAction = createdSetWorkflowActions.get(workflow)
			actionRef.setActionRef(customAction)
			
			containingActionDef.replace(actionRef)
		]
		
	}
	
	private def transformWorkflowProceedActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction workflowAction
	) {
		// get random controller element to place the action in
		val controller = controllers.last
		
		// get all WorkflowProceedActions
		val workflowProceedActions = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(WorkflowProceedAction)
		].flatten
		
		if (workflowProceedActions.empty) {
			return
		}
		
		// Create custom action that sets the 'virtual' event <i>action.proceed</i> and calls the
		// __workflowExecuteAction.
		val customAction = buildWorkflowActionTriggerAction(
			"__workflowActionEventTrigger_proceed", "__action.proceed", entity, contentProvider, workflowAction
		)
		controller.controllerElements.add(customAction)
		
		// Replace all WorkflowProceedActions with the newly created custom action.
		workflowProceedActions.forEach[ workflowProceedAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			actionRef.setActionRef(customAction)
			
			val containingActionDef = workflowProceedAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	private def transformWorkflowReverseActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction workflowAction
	) {
		// get random controller element to place the action in
		val controller = controllers.last
		
		// get all WorkflowReverseActions
		val workflowReverseActions = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(WorkflowReverseAction)
		].flatten
		
		if (workflowReverseActions.empty) {
			return
		}
		
		// Create custom action that sets the 'virtual' event <i>action.reverse</i> and calls the
		// __workflowExecuteAction.
		val customAction = buildWorkflowActionTriggerAction(
			"__workflowActionEventTrigger_reverse", "__action.reverse", entity, contentProvider, workflowAction
		)
		controller.controllerElements.add(customAction)
		
		// Replace all WorkflowReverseActions with the newly created custom action.
		workflowReverseActions.forEach[ workflowReverseAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			actionRef.setActionRef(customAction)
			
			val containingActionDef = workflowReverseAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	private def transformWorkflowGotoActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction workflowAction
	) {
		// get random controller element to place the action in
		val controller = controllers.last
		
		// get all WorkflowGotoActions
		val workflowGotoActions = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(WorkflowGotoAction)
		].flatten
		
		// remember all __workflowActionEventTrigger_goto### actions that are already created, so that for each step
		// only one such action is created
		val createdWorkflowGotoActions = newHashMap
		
		// Create custom action that sets the 'virtual' event <i>action.goto.stepID</i> and calls the
		// __workflowExecuteAction. For each WorkflowGotoAction that points to a different step one of these
		// actions is build and stored in a hash map.
		workflowGotoActions.forEach[ workflowGotoAction |
			val workflowStep = workflowGotoAction.wfStep
			if (!createdWorkflowGotoActions.containsKey(workflowStep)) {
				val customActionName = "__workflowActionEventTrigger_goto" + workflowStep.stringRepresentationOfStep.sha1Hex
				val eventIdentifier = "__action.goto." + workflowStep.stringRepresentationOfStep
				val customAction = buildWorkflowActionTriggerAction(
					customActionName, eventIdentifier, entity, contentProvider, workflowAction
				)
				createdWorkflowGotoActions.put(workflowStep, customAction)
				controller.controllerElements.add(customAction)
			}
		]
		
		// Replace all WorkflowGotoActions with the appropriate custom action from the hash map.
		workflowGotoActions.forEach[ workflowGotoAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			val customAction = createdWorkflowGotoActions.get(workflowGotoAction.wfStep)
			actionRef.setActionRef(customAction)
			
			val containingActionDef = workflowGotoAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	
	////////////////////////////////////////////////
	// Helper methods
	////////////////////////////////////////////////
	
	/**
	 * Helper to create a non-ambiguous string representation for events.
	 */
	private def getStringRepresentationOfEvent(EventDef event) {
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
			ContentProviderPathEventRef: {
				val path = event.pathDefinition
				switch (path) {
					ContentProviderPath: "__contentProvider." + path.contentProviderRef.name + "." + path.tail.pathTailAsString + "." + event.event.toString
					LocationProviderPath: "__contentProvider.location." + path.locationField.toString
				}
			}
			ContentProviderEventRef: {
				val contentProviderRef = event.contentProvider
				switch (contentProviderRef) {
					ContentProviderReference: "__contentProvider." + contentProviderRef.contentProvider.name + "." + event.event.toString
					LocationProviderReference: "__contentProvider.location"
				}
			}
			GlobalEventRef: "__global." + event.event.toString
			ConditionalEventRef: "__conditional." + event.eventReference.name
		}
	}
	
	/**
	 * Helper to create the string representation of a workflow step name of the form <i>workflowName__stepName</i>.
	 */
	private def getStringRepresentationOfStep(WorkflowStep step) {
		val workflow = step.eContainer as Workflow
		return workflow.name + "__" + step.name
	}
	
	/**
	 * Helper to build a conditional expression of the form <code>contentProvider.attributeName equals "compareWith"</code>.
	 */
	private def createCompareExpression(
		Entity entity, ContentProvider contentProvider, String attributeName, String compareWith
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
	
	/**
	 * Helper to build a custom action with a given actionName that sets the <i>lastEventFired</i> attribute of the
	 * <i>__workflowControllerStateEntity</i> to a given string representation of the triggered event. Afterwards it
	 * calls the <i>__workflowExecuteStepAction</i>.
	 * 
	 * @return The newly created CustomAction.
	 */
	private def buildWorkflowActionTriggerAction(
		String actionName, String eventRepresentation, Entity entity, ContentProvider contentProvider,
		CustomAction workflowAction
	) {
		val customAction = factory.createCustomAction
		customAction.setName(actionName)
		
		// set task
		val setTask = factory.createAttributeSetTask
		customAction.codeFragments.add(setTask)
		
		val stringVal = factory.createStringVal
		stringVal.setValue(eventRepresentation)
		setTask.setSource(stringVal)
		
		val pathDefinition = factory.createContentProviderPath
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
		
		return customAction
	}
	
	/**
	 * Helper to build a conditional expression of the form
	 * <code>(lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")</code>
	 * with <code>evtN</code> being the string representation of an event as calculated in <i>getStringRepresentationOfEvent</i>
	 * or the string representation of an Workflow navigation action (i.e, WorkflowProceed, WorkflowReverse and WorkflowGoto).
	 * 
	 * @return ConditionalExpression
	 */
	private def matchAllEventsCondition(
		Collection<WorkflowGoToDefinition> gotos, Entity entity, ContentProvider contentProvider
	) {
		// configure the conditional expression to match all events
		// (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")
		val events = gotos.map[ g |
			g.spec.events.map(e | e.stringRepresentationOfEvent)
		].flatten.toSet
		
		// add conditional expression that matches the WorkflowProceed, WorkflowReverse and WorkflowGoto actions
		val navigationActions = gotos.map[ g |
			val workflowGoTo = g.goto
			switch workflowGoTo {
				WorkflowGoToNext: "__action.proceed"
				WorkflowGoToPrevious: "__action.reverse"
				WorkflowGoToStep: "__action.goto." + workflowGoTo.workflowStep.stringRepresentationOfStep
			}
		].toSet
		
		// merge both sets into a new hash set
		val allCompareStrings = newHashSet
		allCompareStrings.addAll(events)
		allCompareStrings.addAll(navigationActions)
		
		// build the conditional expression to match all events and actions
		val compareExpressions = allCompareStrings.map[ str |
			createCompareExpression(entity, contentProvider, "lastEventFired", str)
		]
		
		// if no events and actions are specified, set condition to false
		val eventsSubCondition = if (!compareExpressions.empty) {
			factory.createComplexOr(compareExpressions.iterator)
		} else {
			val booleanExpr = factory.createBooleanExpression
			booleanExpr.setValue(Boolean::FALSE)
			booleanExpr
		}
		
		return eventsSubCondition
	}
	
}
