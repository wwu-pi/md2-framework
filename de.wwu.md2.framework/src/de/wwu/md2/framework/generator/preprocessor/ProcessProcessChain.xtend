package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.ActionDef
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.Boolean
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.IfCodeBlock
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.SetProcessChainAction
import de.wwu.md2.framework.mD2.ProcessChain
import de.wwu.md2.framework.mD2.ProcessChainGoTo
import de.wwu.md2.framework.mD2.ProcessChainGoToDefinition
import de.wwu.md2.framework.mD2.ProcessChainGoToNext
import de.wwu.md2.framework.mD2.ProcessChainGoToPrevious
import de.wwu.md2.framework.mD2.ProcessChainGoToSpecExtended
import de.wwu.md2.framework.mD2.ProcessChainGoToStep
import de.wwu.md2.framework.mD2.ProcessChainGotoAction
import de.wwu.md2.framework.mD2.ProcessChainProceedAction
import de.wwu.md2.framework.mD2.ProcessChainReturn
import de.wwu.md2.framework.mD2.ProcessChainReverseAction
import de.wwu.md2.framework.mD2.ProcessChainStep
import java.util.Collection
import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject

import static extension de.wwu.md2.framework.generator.preprocessor.util.Helper.*
import static extension org.apache.commons.codec.digest.DigestUtils.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*import de.wwu.md2.framework.mD2.WorkflowElement

class ProcessProcessChain extends AbstractPreprocessor {
	
	////////////////////////////////////////////////
	// ProcessChain Transformation Methods
	////////////////////////////////////////////////
	
	/**
	 * <p>Transforms all processChain definitions as well as the ProcessChainProceed, ProcessChainReverse, ProcessChainGoto and SetProcessChain actions to the core
	 * MD2 language elements. Therefore, a the following elements are created:</p>
	 * 
	 * <p><i>__ProcessChainControllerStateEntity</i> with its <i>__processChainControllerStateEntityProvider</i>: Stores the current processChain step that is
	 * executed as well as a string representation of the event that lead to the execution of <i>__processChainProcessAction</i>.</p>
	 * 
	 * <p><i>__ProcessChainReturnStepStack</i> with its according provider <i>__processChainReturnStepStackProvider</i>: A recursively defined stack that
	 * stores the current processChain step in case of 'goto' statements to allow to return to this step.</p>
	 * 
	 * <p><i>__processChainExecuteAction</i>: A custom action that executes the actual processChain step stored in the "currentProcessChainStep" attribute of the
	 * <i>__processChainControllerStateEntityProvider</i>. Currently, it only goes to the view defined in the target step, but it can easily be extended to
	 * support further features.</p>
	 * 
	 * <p><i>__processChainProcessAction</i>: This action is the heart, or the central component of the processChain processing. Based on the current processChain step,
	 * the event that triggered the call of this action and the 'given' conditions specified in each processChain step, it is decided which processChain step to
	 * execute next. So, based on the state in the <i>__processChainControllerStateEntityProvider</i>, it decides which information to write in the
	 * <i>__processChainReturnStepStackProvider</i> and which step is executed next by the <i>__processChainExecuteAction</i> action.</p>
	 * 
	 * <p>Several <i>__processChainActionTriggerAction_###uniqueIdentifier###</i>s: Events in MD2 cannot be identified. Thus, the target action cannot know by
	 * which event it was triggered if it is bound to multiple events. As a workaround <i>__processChainActionTriggerAction</i>s are created for each different
	 * event. As this action is only bound to one event it always knows by which event it was triggered. This action then writes a string representation of
	 * the event by which it was triggered to the "lastEventFired" attribute of the <i>__processChainControllerStateEntityProvider</i>. Then it executes the actual
	 * <i>__processChainProcessAction</i> that was supposed to be triggered by the event.</p>
	 * 
	 * <p>Detailed explanations of the according structures are given in the comments on the methods that create the actual elements.</p>
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - It is assumed that a __startUp action exists where the event bindings
	 *     for the processChainActionTriggers can be placed.
	 *   </li>
	 *   <li>
	 *     <i>createInitialGotoViewOrSetProcessChainAction</i> - All SetProcessChainActions will be transformed to core MD2 elements in this step. Thus,
	 *     it is necessary, that the <i>SetProcessChainAction</i> for the default processChain has already been created.
	 *   </li>
	 * </ul>
	 */
	def transformProcessChainsToSequenceOfCoreLanguageElements() {
		
		// only run this task if there are processChains present
		val hasProcessChains = controller.eAllContents.exists( e | e instanceof ProcessChain)
		
		if (!hasProcessChains) {
			return
		}
		
		val workflowElements = controller.controllerElements.filter(WorkflowElement)
		//////////////////////////////////////
		// Sub-Steps
		//////////////////////////////////////
		
		// Transform ProcessChain element
		
		//TODO: Is it sufficient to have only one of those three objects but call all other methods multiple times (e.g. returnStepStack)
		val returnStepStack = createReturnStepStack
		val controllerStateEntity = createProcessChainControllerStateEntity
		val controllerStateCP = createProcessChainControllerStateContentProvider(controllerStateEntity)
		workflowElements.forEach[wfe |
			val processChainExecuteStepAction = createExecuteStepCustomAction(controllerStateEntity, controllerStateCP, wfe)
			val processChainAction = createProcessChainProcessAction(controllerStateEntity, controllerStateCP, processChainExecuteStepAction, returnStepStack, wfe)
			val eventActionMap = createProcessChainActionTriggerActions(controllerStateEntity, controllerStateCP, processChainAction, wfe)
			registerProcessChainActionTriggerActionsOnStartup(eventActionMap, wfe)
		
		
			// Transform all SimpleActions for the processChain control
			transformSetProcessChainActionToCustomActionCall(controllerStateEntity, controllerStateCP, processChainExecuteStepAction, wfe)
			transformProcessChainProceedActionToCustomActionCall(controllerStateEntity, controllerStateCP, processChainExecuteStepAction, wfe)
			transformProcessChainReverseActionToCustomActionCall(controllerStateEntity, controllerStateCP, processChainExecuteStepAction, wfe)
			transformProcessChainGotoActionToCustomActionCall(controllerStateEntity, controllerStateCP, processChainExecuteStepAction, wfe)
		]
		// Remove actual processChain after everything has been transformed
		removeProcessChains
	}
	
	/**
	 * <p>Create entity that stores the current state of the processChain and populate it with the required attributes
	 * <code>currentProcessChainStep : STRING</code> and <code>lastEventFired : STRING</code>. <code>currentProcessChainStep</code>
	 * stores the current processChain name and stepname in the form <i>processChain__step</i>. <code>lastEventFired</code> always keeps
	 * the name of the event that triggered the <code>__ProcessChainProcessAction</code>).</p>
	 * 
	 * <p>MD2 code that is generated:</p>
	 * <pre>
	 * entity __ProcessChainControllerState {
	 *   currentProcessChainStep: string
	 *   lastEventFired: string
	 * }
	 * </pre>
	 */
	private def createProcessChainControllerStateEntity() {
		
		// Create entity
		val stringType = factory.createStringType
		val controllerStateEntity = factory.createComplexEntity(
			"__ProcessChainControllerState",
			"currentProcessChainStep" -> stringType,
			"lastEventFired" -> stringType
		)
		
		model.modelElements.add(controllerStateEntity)
		
		return controllerStateEntity
	}
	
	/**
	 * Create content provider for <code>__ProcessChainControllerState</code> entity.
	 */
	private def createProcessChainControllerStateContentProvider(Entity controllerStateEntity) {
		
		// Create content provider
		val contentProvider = factory.createComplexContentProvider(
			controllerStateEntity,
			"__processChainControllerStateProvider",
			true,
			false
		)
		
		controller.controllerElements.add(contentProvider)
		
		return contentProvider
	}
	
	/**
	 * For each event create an action that sets the name of the event to the <i>lastEventFired</i> attribute and calls the actual
	 * processChain processing action. These actions are then bound to the according events. This can be seen as a workaround, because
	 * in MD2 there is no way to find out which event triggered a particular action.
	 */
	private def createProcessChainActionTriggerActions(Entity entity, ContentProvider contentProvider, CustomAction processChainAction, WorkflowElement wfe) {
		
		val processChains = wfe.processChain
		
		// get all events of all processChains
		val gotos = processChains.map(wf | wf.processChainSteps).flatten.map(step | step.gotos).flatten
		val eventMap = newHashMap
		gotos.map(g | g.spec.events).flatten.forEach[ event |
			eventMap.put(event.stringRepresentationOfEvent, event)
		]
		
		// create actions and store them in a map of (event->action) pairs
		val eventActionMap = newHashMap
		eventMap.forEach[ str, event |
			
			val customAction = buildProcessChainActionTriggerAction(
				"__processChainActionEventTrigger_" + str.sha1Hex, str, entity, contentProvider, processChainAction
			)
			
			wfe.actions.add(customAction)
			eventActionMap.put(event, customAction)
		]
		
		return eventActionMap
	}
	
	/**
	 * For each event that occurs in any of the processChain steps, create event binding tasks in the startup action that
	 * trigger the ProcessChainActionTriggerActions created in the step <i>createProcessChainActionTriggerActions</i>.
	 */
	private def registerProcessChainActionTriggerActionsOnStartup(HashMap<EventDef, CustomAction> eventActionMap, WorkflowElement wfe) {
		
		// create custom action to register all events
		val customAction = factory.createCustomAction
		customAction.setName("__registerProcessChainActionEventTrigger")
		wfe.actions.add(customAction)
		
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
		val startupAction = wfe.initActions.filter(CustomAction).head
//		TODO: code fragment in comment can be totally removed when DSL is changed 
//		val startupAction = controllers.map[ ctrl |
//			ctrl.controllerElements.filter(CustomAction)
//				.filter( action | action.name.equals(ProcessController::startupActionName))
//		].flatten.last
		val callTask = factory.createCallTask
		val actionDef = factory.createActionReference
		actionDef.setActionRef(customAction)
		callTask.setAction(actionDef)
		startupAction.codeFragments.add(0, callTask);
	}
	
	/**
	 * Creates a recursively defined stack named <i>__ReturnStepStack</i> that consists of an entity (with
	 * the fields <i>returnStep</i>, <i>returnAndReverseStep</i> and <i>returnAndProceedStep</i>) and its according
	 * content provider.
	 */
	private def createReturnStepStack() {
		
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
	
	/**
	 * Creates a CustomAction that executes the actual processChain step that should be executed next. It consists of
	 * if blocks that check in which processChain step we currently are (value of the "currentProcessChainStep" field of
	 * the <i>__processChainStateProvider</i>) and then calls the respective GotoViewAction.
	 * <pre>
	 * if (:__processChainStateProvider.currentProcessChainStep equals "myWf1_myStep1") {
	 *   call GotoView(myView1)
	 * }
	 * else if (:__processChainStateProvider.currentProcessChainStep equals "myWf1_myStep2") {
	 *   call GotoView(myView2)
	 * }
	 * .
	 * .
	 * .
	 * else if (:__processChainStateProvider.currentProcessChainStep equals "myWfN_myStepM") {
	 *   call GotoView(myViewK)
	 * }
	 * </pre>
	 */
	private def createExecuteStepCustomAction(Entity entity, ContentProvider contentProvider, WorkflowElement wfe) {
		
		val processChainSteps = wfe.processChain.map[ p |
				p.processChainSteps
			].flatten
		
		val customAction = factory.createCustomAction
		customAction.setName("__processChainExecuteStepAction")
		//TODO: create on customAction for each workflowelement and add each to the workflowElement. Next line is only a dirty bug fix.
		wfe.actions.add(customAction)
		
		val conditionalCodeFragment = factory.createConditionalCodeFragment
		if (!processChainSteps.empty) {
			customAction.codeFragments.add(conditionalCodeFragment)
		}
		
		processChainSteps.forEach[ step, index |
			val stepStr = step.stringRepresentationOfStep
			val conditionalExpression = createCompareExpression(entity, contentProvider, "currentProcessChainStep", stepStr)
			
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
			
			// add ifCodeBlock => first element if(...); all other elements elseif(...)
			if (index == 0) {
				conditionalCodeFragment.setIf(ifCodeBlock)
			} else {
				conditionalCodeFragment.elseifs.add(ifCodeBlock)
			}
		]
		
		return customAction
	}
	
	/**
	 * Cleanup after transforming all processChain to MD2 core language elements. Removes all processChains
	 * from the model.
	 */
	private def removeProcessChains() {
		val processChains = controller.controllerElements.filter(WorkflowElement).map[w|w.processChain
		].flatten
		
		while (!processChains.empty) {
			processChains.last.remove
		}
	}
	
	
	////////////////////////////////////////////////
	// ProcessChain Actions
	////////////////////////////////////////////////
	
	/**
	 * Replace the SetProcessChainAction with a CustomAction action that sets the current processChain step in the
	 * <code>__processChainControllerStateProvider</code> to the first step of the specified processChain and then executes
	 * the <code>__processChainExecuteStepAction</code> to go to the actual view.
	 * 
	 * First custom actions that set and go to the respective processChain are created for all SetProcessChainActions, then
	 * in a second step all SetProcessChainActions are replaced with the newly created custom actions.
	 */
	private def transformSetProcessChainActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction processChainExecuteStepAction, WorkflowElement wfe
	) {
			
		// get all SetProcessChainActions
		val setProcessChainActions = wfe.eAllContents.toIterable.filter(SetProcessChainAction).toList
		
		// remember all SetProcessChain###Actions that are already created, so that for each processChain only one such
		// action is created
		val createdSetProcessChainActions = newHashMap
		
		// Step 1:
		// Create custom actions for all SetProcessChainActions that set the new processChain step in the
		// content provider and then call the __processChainExecuteStepAction.
		setProcessChainActions.forEach[ setProcessChainAction |
			
			val processChain = setProcessChainAction.processChain
			
			if (!createdSetProcessChainActions.containsKey(processChain)) {
				
				val customAction = factory.createCustomAction
				customAction.setName("__processChainSetProcessChain" + processChain.name.toFirstUpper + "Action")
				wfe.actions.add(customAction)
				createdSetProcessChainActions.put(processChain, customAction)
				
				// create attribute set task
				{
					val stringVal = factory.createStringVal
					val targetStep = processChain.processChainSteps.head.stringRepresentationOfStep
					stringVal.setValue(targetStep)
					
					val attributeSetTask = factory.createAttributeSetTask
					val attribute = entity.attributes.findFirst[ a | a.name.equals("currentProcessChainStep")]
					val targetPathDefinition = factory.createComplexContentProviderPathDefinition(contentProvider, attribute)
					attributeSetTask.setPathDefinition(targetPathDefinition)
					
					attributeSetTask.setSource(stringVal)
					
					customAction.codeFragments.add(attributeSetTask)
				}
				
				// create call task for the __processChainExecuteStepAction (that changes the actual view)
				{
					val callTask = factory.createCallTask
					val actionDef = factory.createActionReference
					actionDef.setActionRef(processChainExecuteStepAction)
					callTask.setAction(actionDef)
					customAction.codeFragments.add(callTask)
				}
			}
		]
		
		// Step2:
		// Replace all SetProcessChainActions with the newly created custom actions.
		setProcessChainActions.forEach[ setProcessChainAction |
			
			val processChain = setProcessChainAction.processChain
			val containingActionDef = setProcessChainAction.eContainer as ActionDef
			
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			val customAction = createdSetProcessChainActions.get(processChain)
			actionRef.setActionRef(customAction)
			
			containingActionDef.replace(actionRef)
		]
		
	}
	
	/**
	 * Replaces all ProcessChainProceedActions with <i>ProcessChainActionTriggerAction</i>s (custom action built in method
	 * buildProcessChainActionTriggerAction). The call of a ProcessChainProceedAction is handled as the firing of an pseudo event
	 * called "__action.proceed".
	 */
	private def transformProcessChainProceedActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction processChainAction, WorkflowElement wfe
	) {
		
		// get all ProcessChainProceedActions
		val processChainProceedActions = wfe.eAllContents.toIterable.filter(ProcessChainProceedAction)
		
		if (processChainProceedActions.empty) {
			return
		}
		
		// Create custom action that sets the 'virtual' event <i>action.proceed</i> and calls the
		// __processChainExecuteAction.
		val customAction = buildProcessChainActionTriggerAction(
			"__processChainActionEventTrigger_proceed", "__action.proceed", entity, contentProvider, processChainAction
		)
		wfe.actions.add(customAction)
		
		// Replace all ProcessChainProceedActions with the newly created custom action.
		processChainProceedActions.forEach[ processChainProceedAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			actionRef.setActionRef(customAction)
			
			val containingActionDef = processChainProceedAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	/**
	 * Replaces all ProcessChainReverseActions with <i>ProcessChainActionTriggerAction</i>s (custom action built in method
	 * buildProcessChainActionTriggerAction). The call of a ProcessChainReverseAction is handled as the firing of an pseudo event
	 * called "__action.reverse".
	 */
	private def transformProcessChainReverseActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction processChainAction, WorkflowElement wfe
	) {
		
		// get all ProcessChainReverseActions
		val processChainReverseActions = wfe.eAllContents.toIterable.filter(ProcessChainReverseAction)
		
		if (processChainReverseActions.empty) {
			return
		}
		
		// Create custom action that sets the 'virtual' event <i>action.reverse</i> and calls the
		// __processChainExecuteAction.
		val customAction = buildProcessChainActionTriggerAction(
			"__processChainActionEventTrigger_reverse", "__action.reverse", entity, contentProvider, processChainAction
		)
		wfe.actions.add(customAction)
		
		// Replace all ProcessChainReverseActions with the newly created custom action.
		processChainReverseActions.forEach[ processChainReverseAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			actionRef.setActionRef(customAction)
			
			val containingActionDef = processChainReverseAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	/**
	 * Replaces all ProcessChainGotoActions with <i>ProcessChainActionTriggerAction</i>s (custom action built in method
	 * buildProcessChainActionTriggerAction). The call of a ProcessChainGotoAction is handled as the firing of an pseudo event
	 * called "__action.goto.###" with ### being the name of target processChain step as created by the method
	 * <i>stringRepresentationOfStep</i>.
	 */
	private def transformProcessChainGotoActionToCustomActionCall(
		Entity entity, ContentProvider contentProvider, CustomAction processChainAction, WorkflowElement wfe
	) {

		// get all ProcessChainGotoActions
		val processChainGotoActions =wfe.eAllContents.toIterable.filter(ProcessChainGotoAction)
		
		// remember all __processChainActionEventTrigger_goto### actions that are already created, so that for each step
		// only one such action is created
		val createdProcessChainGotoActions = newHashMap
		
		// Create custom action that sets the 'virtual' event <i>action.goto.stepID</i> and calls the
		// __processChainExecuteAction. For each ProcessChainGotoAction that points to a different step one of these
		// actions is build and stored in a hash map.
		processChainGotoActions.forEach[ processChainGotoAction |
			val processChainStep = processChainGotoAction.pcStep
			if (!createdProcessChainGotoActions.containsKey(processChainStep)) {
				val customActionName = "__processChainActionEventTrigger_goto" + processChainStep.stringRepresentationOfStep.sha1Hex
				val eventIdentifier = "__action.goto." + processChainStep.stringRepresentationOfStep
				val customAction = buildProcessChainActionTriggerAction(
					customActionName, eventIdentifier, entity, contentProvider, processChainAction
				)
				createdProcessChainGotoActions.put(processChainStep, customAction)
				wfe.actions.add(customAction)
			}
		]
		
		// Replace all ProcessChainGotoActions with the appropriate custom action from the hash map.
		processChainGotoActions.forEach[ processChainGotoAction |
			// build the SimpleActionRef that contains the cross-reference to the actual custom action
			val actionRef = factory.createActionReference
			val customAction = createdProcessChainGotoActions.get(processChainGotoAction.pcStep)
			actionRef.setActionRef(customAction)
			
			val containingActionDef = processChainGotoAction.eContainer as ActionDef
			containingActionDef.replace(actionRef)
		]
	}
	
	
	/////////////////////////////////////////////////////////////////////
	// Step: createProcessChainProcessAction (divided into sub methods for
	//       better understandability)
	/////////////////////////////////////////////////////////////////////
	
	/**
	 * The heart of the processChain processing. A custom action that is in charge of selecting the processChain step that has to be executed next.
	 * It creates an outer if block that determines in which processChain step we are by looking up the "currentProcessChainStep" attribute value in the
	 * <i>__processChainControllerStateProvider</i>. Once the current processChain step is determined, the inner code block as created in the
	 * method <i>createProcessChainProcessActionInnerIfBlock</i> is executed.
	 * 
	 * <pre>
	 * if (:__processChainStateProvider.currentProcessChainStep equals "myWf1_myStep1") {
	 *   // inner code block 1
	 * }
	 * else if (:__processChainStateProvider.currentProcessChainStep equals "myWf1_myStep2") {
	 *   // inner code block 2
	 * }
	 * .
	 * .
	 * .
	 * else if (:__processChainStateProvider.currentProcessChainStep equals "myWfN_myStepM") {
	 *   // inner code block N*M
	 * }
	 * </pre>
	 */
	private def createProcessChainProcessAction(
		Entity entity, ContentProvider contentProvider, CustomAction processChainExecuteStepAction, HashMap<String, EObject> stack, WorkflowElement wfe
	) {
		val processChains = wfe.processChain
				
		// createAction
		val customAction = factory.createCustomAction
		customAction.setName("__processChainProcessingAction")
		wfe.actions.add(customAction)
		
		// add conditional code fragment to the custom action
		val conditionalCodeFragment = factory.createConditionalCodeFragment
		customAction.codeFragments.add(conditionalCodeFragment)
		
		// populate conditional code fragment:
		// create if { ...wf1_step1_code... }, elseif { ...wf1_step2_code... }, elseif { ...wf1_stepN_code... }, ..., elseif { ...wfN_stepM_code... }
		processChains.forEach[ processChain, wfIndex |
			val steps = processChain.processChainSteps
			steps.forEach[ step, stepIndex |
				
				///////////////////////////////////////////////////////
				// Outer if...elseif...
				// Decide in which ProcessChain Step we are
				///////////////////////////////////////////////////////
				
				// Create outer ifCodeBlock with condition
				val outerIfCodeBlock = factory.createIfCodeBlock
				
				{
					val stepStr = step.stringRepresentationOfStep
					val conditionalExpression = createCompareExpression(entity, contentProvider, "currentProcessChainStep", stepStr)
					
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
				// Decide whether the condition for a processChain step
				// change is satisfied and whether the right event
				// was fired.
				///////////////////////////////////////////////////////
				
				val gotos = step.gotos
				
				if (!gotos.empty) {
					val innerConditionalCodeFragment = createProcessChainProcessActionInnerIfBlock(
						gotos, steps, step, stepIndex, entity, contentProvider, processChainExecuteStepAction, stack
					)
					outerIfCodeBlock.codeFragments.add(innerConditionalCodeFragment)
				}
				
			]
		]
		
		return customAction
	}
	
	/**
	 * The inner code block can be seen as a switch that decides which goto is executed. The if conditions check whether any of the
	 * events defined in "on" (or any of the pseudo events triggered by ProcessChainProceed, ProcessChainReverse or ProcessChainGoto) triggered
	 * the processChain processing action and if specified, whether the condition "given" is satisfied. If none of the conditions is satisfied,
	 * in a last elseif block it is checked whether any of the events that are handled by this processChain step was fired at all. If that is the case,
	 * the message specified in "message" is displayed. If no message is specified or if none of the events matched nothing happens.
	 * This method builds the conditions and calls the methods <i>createProcessChainProcessActionInnerIfBlockCodeFragment</i> to build the actual code
	 * block for each of the if statements and <i>createProcessChainProcessActionInnerIfBlockMessage</i> to create the DisplayMessageAction.
	 * 
	 * <pre>
	 * if (#check for current step, c.f. method createProcessChainProcessAction) {
	 *   if ((:__processChainStateProvider.lastEventFired equals "myEvtA" or :__processChainStateProvider.lastEventFired equals "myEvtB" or ...) and GIVEN_COND1) {
	 *     // inner code block 1
	 *   }
	 *   else if ((:__processChainStateProvider.lastEventFired equals "myEvtA" or :__processChainStateProvider.lastEventFired equals "myEvtC" or ...) and GIVEN_COND2) {
	 *     // inner code block 2
	 *   }
	 *   .
	 *   .
	 *   .
	 *   else if (:__processChainStateProvider.lastEventFired equals "myEvtA" or :__processChainStateProvider.lastEventFired equals "myEvtB" or :__processChainStateProvider.lastEventFired equals "myEvtC") {
	 *     call DisplayMessageAction("any message")
	 *   }
	 * }
	 * .
	 * .
	 * .
	 * </pre>
	 */
	private def createProcessChainProcessActionInnerIfBlock(
		List<ProcessChainGoToDefinition> gotos, List<ProcessChainStep> steps, ProcessChainStep step, int stepIndex,
		Entity entity, ContentProvider contentProvider, CustomAction processChainExecuteStepAction, HashMap<String, EObject> stack
	) {
		
		val innerConditionalCodeFragment = factory.createConditionalCodeFragment
		
		// create one inner if block per goto
		gotos.forEach[ goto, gotoIndex |
			
			val processChainGoTo = goto.goto
			
			
			//////////////////////////////////////////////////////////
			// Create inner ifCodeBlock and its according condition
			//////////////////////////////////////////////////////////
			
			val innerIfCodeBlock = factory.createIfCodeBlock
			
			// configure the conditional expression to match all events and the ProcessChainProceed,
			// ProcessChainReverse and ProcessChainGoto simple action calls
			// (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")
			val eventsSubCondition = matchAllEventsCondition(newHashSet(goto), entity, contentProvider)
			
			// add 'given' condition of goto specification (with 'and')
			val given = if (goto.spec instanceof ProcessChainGoToSpecExtended && (goto.spec as ProcessChainGoToSpecExtended).condition != null) {
				(goto.spec as ProcessChainGoToSpecExtended).condition
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
			
			createProcessChainProcessActionInnerIfBlockCodeFragment(
				gotos, steps, step, stepIndex, processChainGoTo, innerIfCodeBlock, goto, entity,
				contentProvider, processChainExecuteStepAction, stack
			)
			
			
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
			val ifCodeBlock = createProcessChainProcessActionInnerIfBlockMessage(gotos, step, entity, contentProvider)
			innerConditionalCodeFragment.elseifs.add(ifCodeBlock)
		}
		
		return innerConditionalCodeFragment
	}
	
	/**
	 * Creates the DisplayMessageAction for the case that none of the gotos matched.
	 */
	private def createProcessChainProcessActionInnerIfBlockMessage(
		List<ProcessChainGoToDefinition> gotos, ProcessChainStep step, Entity entity, ContentProvider contentProvider
	) {
		val ifCodeBlock = factory.createIfCodeBlock
		val condition = matchAllEventsCondition(gotos, entity, contentProvider)
		ifCodeBlock.setCondition(condition)
		
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
		
		return ifCodeBlock
	}
	
	/**
	 * <p>Creates the actual code fragment for the if conditions that are created in the method <i>createProcessChainProcessActionInnerIfBlock</i>.
	 * It sets the value of the "currentProcessChainStep" attribute in the <i>__processChainStateControllerProvider</i> to the next step that should be
	 * executed and calls the <i>__processChainExecuteStepAction</i> to get switch to the next processChain step.</p>
	 * 
	 * <p>If it is a 'goto' statement, also generate the code to put information about the current step on the <i>__processChainReturnStack</i> to allow
	 * to return to the previous step. If this is a 'return' statement, remove the current head step from the <i>__processChainReturnStack</i>.</p>
	 */
	private def createProcessChainProcessActionInnerIfBlockCodeFragment(
		List<ProcessChainGoToDefinition> gotos, List<ProcessChainStep> steps, ProcessChainStep step, int stepIndex, ProcessChainGoTo processChainGoTo,
		IfCodeBlock innerIfCodeBlock, ProcessChainGoToDefinition goto, Entity entity, ContentProvider contentProvider, CustomAction processChainExecuteStepAction,
		HashMap<String, EObject> stack
	) {
		// set current processChain step
		{
			val currentProcessChainStepVal = getCurrentProcessChainStepValue(steps, stepIndex, processChainGoTo, stack)
			
			val attributeSetTask = factory.createAttributeSetTask
			val attribute = entity.attributes.findFirst[ a | a.name.equals("currentProcessChainStep")]
			val targetPathDefinition = factory.createComplexContentProviderPathDefinition(contentProvider, attribute)
			attributeSetTask.setPathDefinition(targetPathDefinition)
			
			attributeSetTask.setSource(currentProcessChainStepVal)
			
			innerIfCodeBlock.codeFragments.add(attributeSetTask)
		}
		
		// if this is a 'goto' statement => put current step on stack to allow to return
		if (processChainGoTo instanceof ProcessChainGoToStep) {
			val processChainGoToStep = processChainGoTo as ProcessChainGoToStep
			createCodeToAddStepToReturnStack(processChainGoToStep, steps, step, stepIndex, innerIfCodeBlock, stack)
		}
		
		// if this is a 'return' statement => remove current head step from stack
		if (processChainGoTo instanceof ProcessChainReturn) {
			val contentProviderSetTask = stack.get("removeHeadTask") as ContentProviderSetTask
			innerIfCodeBlock.codeFragments.add(contentProviderSetTask)
		}
		
		// create call task for the __processChainExecuteStepAction (that changes the actual view)
		{
			val callTask = factory.createCallTask
			val actionDef = factory.createActionReference
			actionDef.setActionRef(processChainExecuteStepAction)
			callTask.setAction(actionDef)
			innerIfCodeBlock.codeFragments.add(callTask)
		}
		
		// create action to execute after view change ('then' statement)
		if (goto.spec instanceof ProcessChainGoToSpecExtended && (goto.spec as ProcessChainGoToSpecExtended).action != null) {
			val callTask = factory.createCallTask
			val actionDef = (goto.spec as ProcessChainGoToSpecExtended).action
			callTask.setAction(actionDef.copy)
			innerIfCodeBlock.codeFragments.add(callTask)
		}
	}
	
	/**
	 * If the inner code block of the <i>__processChainProcessAction</i> defines a 'goto' statement, generate the code to put information
	 * about the current step on the <i>__processChainReturnStack</i> to allow to return to this step later on. Therefore, calculate the next
	 * and the previous step. If they exist, put their string representations on the step. Otherwise, put an empty string on the stack in
	 * lieu of the actual string representation.
	 */
	private def createCodeToAddStepToReturnStack(
		ProcessChainGoToStep processChainGoToStep, List<ProcessChainStep> steps, ProcessChainStep step, int stepIndex, IfCodeBlock innerIfCodeBlock,
		HashMap<String, EObject> stack
	) {
		
		var currentStep = ""
		var nextStep = ""
		var previousStep = ""
		
		if (processChainGoToStep.returnTo != null) {
			val returnToStep = processChainGoToStep.returnTo
			val returnToStepProcessChain = returnToStep.eContainer as ProcessChain
			val currentStepIndex = returnToStepProcessChain.processChainSteps.indexOf(returnToStep)
			
			currentStep = returnToStep.stringRepresentationOfStep
			nextStep = 
				if(currentStepIndex + 1 >= returnToStepProcessChain.processChainSteps.size) ""
				else returnToStepProcessChain.processChainSteps.get(stepIndex + 1).stringRepresentationOfStep
			previousStep =
				if(currentStepIndex - 1 < 0) ""
				else returnToStepProcessChain.processChainSteps.get(stepIndex - 1).stringRepresentationOfStep
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
	
	/**
	 * Calculates the simple expression with which the value of the "currentProcessChainStep" attribute is compared for equality.
	 * In case of the ProcessChainGoToNext, ProcessChainGoToPrevious and ProcessChainGoToStep definitions this is straight forward. The
	 * string representations of the next, previous or goto step are returned respectively. In case of a return statement,
	 * the target step is popped from the <i>__processChainReturnStepStack</i> => the returned simple expression is a content provider
	 * path expression in those cases.
	 */
	private def getCurrentProcessChainStepValue(
		List<ProcessChainStep> steps, int stepIndex, ProcessChainGoTo processChainGoTo, HashMap<String, EObject> stack
	) {
		switch(processChainGoTo) {
			// no check for indexOutOfBounds => validator required at programming time
			ProcessChainGoToNext: {
				val stringVal = factory.createStringVal
				val targetStep = steps.get(stepIndex + 1).stringRepresentationOfStep
				stringVal.setValue(targetStep)
				stringVal
			}
			ProcessChainGoToPrevious: {
				val stringVal = factory.createStringVal
				val targetStep = steps.get(stepIndex - 1).stringRepresentationOfStep
				stringVal.setValue(targetStep)
				stringVal
			}
			ProcessChainGoToStep: {
				val stringVal = factory.createStringVal
				val targetStep = processChainGoTo.processChainStep.stringRepresentationOfStep
				stringVal.setValue(targetStep)
				stringVal
			}
			ProcessChainReturn: {
				val stackEntity = stack.get("entity") as Entity
				val stackProvider = stack.get("contentProvider") as ContentProvider
				
				val attribute =
					if (processChainGoTo.changeStep && processChainGoTo.changeDirection.equals("proceed")) {
						stackEntity.attributes.findFirst[ a | a.name.equals("returnAndProceedStep")]
					} else if (processChainGoTo.changeStep && processChainGoTo.changeDirection.equals("reverse")) {
						stackEntity.attributes.findFirst[ a | a.name.equals("returnAndReverseStep")]
					} else {
						stackEntity.attributes.findFirst[ a | a.name.equals("returnStep")]
					}
				
				factory.createComplexContentProviderPathDefinition(stackProvider, attribute)
			}
		}
	}
	
	
	/////////////////////////////////////////////////////////////////////
	// Helper methods
	/////////////////////////////////////////////////////////////////////
	
	/**
	 * Helper to create the string representation of a processChain step name of the form <i>processChainName__stepName</i>.
	 */
	private def getStringRepresentationOfStep(ProcessChainStep step) {
		val processChain = step.eContainer as ProcessChain
		return processChain.name + "__" + step.name
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
	 * <i>__processChainControllerStateEntity</i> to a given string representation of the triggered event. Afterwards it
	 * calls the <i>__processChainExecuteStepAction</i>.
	 * 
	 * @return The newly created CustomAction.
	 */
	private def buildProcessChainActionTriggerAction(
		String actionName, String eventRepresentation, Entity entity, ContentProvider contentProvider,
		CustomAction processChainAction
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
		actionDef.setActionRef(processChainAction)
		callTask.setAction(actionDef)
		customAction.codeFragments.add(callTask)
		
		return customAction
	}
	
	/**
	 * Helper to build a conditional expression of the form
	 * <code>(lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")</code>
	 * with <code>evtN</code> being the string representation of an event as calculated in <i>getStringRepresentationOfEvent</i>
	 * or the string representation of an ProcessChain navigation action (i.e, ProcessChainProceed, ProcessChainReverse and ProcessChainGoto).
	 * 
	 * @return ConditionalExpression
	 */
	private def matchAllEventsCondition(
		Collection<ProcessChainGoToDefinition> gotos, Entity entity, ContentProvider contentProvider
	) {
		// configure the conditional expression to match all events
		// (lastEventFired equals "evt1" or lastEventFired equals "evt2" or ... or lastEventFired equals "evtN")
		val events = gotos.map[ g |
			g.spec.events.map(e | e.stringRepresentationOfEvent)
		].flatten.toSet
		
		// add conditional expression that matches the ProcessChainProceed, ProcessChainReverse and ProcessChainGoto actions
		val navigationActions = gotos.map[ g |
			val processChainGoTo = g.goto
			switch processChainGoTo {
				ProcessChainGoToNext: "__action.proceed"
				ProcessChainGoToPrevious: "__action.reverse"
				ProcessChainGoToStep: "__action.goto." + processChainGoTo.processChainStep.stringRepresentationOfStep
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
