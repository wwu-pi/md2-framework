package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.generator.preprocessor.util.AbstractPreprocessor
import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.ContainsCodeFragments
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.CustomizedValidatorType
import de.wwu.md2.framework.mD2.DateRangeValidator
import de.wwu.md2.framework.mD2.DateTimeRangeValidator
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.NotNullValidator
import de.wwu.md2.framework.mD2.NumberRangeValidator
import de.wwu.md2.framework.mD2.RegExValidator
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
import de.wwu.md2.framework.mD2.StringRangeValidator
import de.wwu.md2.framework.mD2.TimeRangeValidator
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension de.wwu.md2.framework.generator.preprocessor.util.Util.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessController extends AbstractPreprocessor {
	
	public static String startupActionName = "__startupAction"
	
	/**
	 * A <i>__startupAction</i> is created and registered in the main block for the onInitialized event. The actual startup action
	 * that was originally declared for the onInitialized event is added to this <i>__startupAction</i>. Other start-up tasks such as the
	 * autoGenerationAction or registerOnConditionalEventActions can be later added here.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def createStartUpActionAndRegisterAsOnInitializedEvent() {
		
		val ctrl = controllers.last
		
		if (ctrl != null) {
			
			// create __startupAction
			val startupAction = factory.createCustomAction;
			startupAction.setName(startupActionName)
			ctrl.controllerElements.add(startupAction)
			
			// register __startupAction as onInitializedEvent in main block
			val main = controllers.map[ c |
				c.eAllContents.toIterable.filter(Main).head
			].head
			val originalStartupAction = main.onInitializedEvent
			main.setOnInitializedEvent(startupAction)
			
			// add original startup action to __startupAction
			val originalCallTask = factory.createCallTask
			val originalActionReference = factory.createActionReference
			originalActionReference.setActionRef(originalStartupAction)
			originalCallTask.setAction(originalActionReference)
			startupAction.codeFragments.add(originalCallTask);
		}
	}
	
	/**
	 * The providerType of a contentProvider can either be remote, local or default. Default is 'local' if no default remoteConnection
	 * is specified in main block, otherwise it is remote with the connection specified in the main block of the controller. This step
	 * explicitly sets the 'local' or 'connection' properties of the contentProvider if 'default' was specified.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def replaceDefaultProviderTypeWithConcreteDefinition() {
		val contentProviders = controllers.map[ ctrl |
			ctrl.controllerElements.filter(ContentProvider)
		].flatten
		
		val main = controllers.map[ ctrl |
			ctrl.controllerElements.filter(Main)
		].flatten.head
		
		for (contentProvider : contentProviders) {
			if (contentProvider.^default && main.defaultConnection == null) {
				contentProvider.setLocal(true)
			} else if (contentProvider.^default && main.defaultConnection != null) {
				contentProvider.setConnection(main.defaultConnection)
			}
		}
	}
	
	/**
	 * Replaces CombinedActions with CustomActions that contain calls to each child action declared in the CombinedAction.
	 * Replaces all references to the CombinedAction with references to the newly created CustomAction.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def replaceCombinedActionWithCustomAction() {
		val combinedActions = controllers.map[ ctrl | 
			ctrl.controllerElements.filter(CombinedAction)
		].flatten
		
		combinedActions.forEach[ combinedAction |
			val custAction = factory.createCustomAction()
			custAction.name = "__combined_" + combinedAction.name
			
			// create call tasks for each referenced task
			combinedAction.actions.forEach [ actionRef |
				val callTask = factory.createCallTask
				val newActionRef = factory.createActionReference
				newActionRef.setActionRef(actionRef)
				callTask.setAction(newActionRef)
				custAction.codeFragments.add(callTask)
			]
			combinedAction.replace(custAction)
			
			// Change all cross references to the new custom action
			val usageReferences = EcoreUtil.UsageCrossReferencer.find(combinedAction, workingInput)
			usageReferences.forEach[ crossReference |
				crossReference.replace(combinedAction, custAction)
			]
		]
	}
	
	/**
	 * Create initial GotoViewAction in <i>__startupAction</i> to load the first view. The start-up action goes to
	 * the view that is defined in the controller's main block. If no startView is specified, a SetWorkflow action
	 * for the startWorkflow is created instead and added to the <i>__startupAction</i> action. Beware that the
	 * SetWorkflowAction is replaced in the workflow processing again as it is no core MD2 element.
	 * 
	 * <p>
	 *   DEPENDENCIES:
	 * </p>
	 * <ul>
	 *   <li>
	 *     <i>createStartUpActionAndRegisterAsOnInitializedEvent</i> - Requires the <i>__startupAction</i> to add the
	 *     GotoViewAction call task.
	 *   </li>
	 * </ul>
	 */
	def createInitialGotoViewOrSetWorkflowAction() {
		
		val main = controllers.map[ ctrl | 
			ctrl.controllerElements.filter(typeof(Main))
		].flatten.head
		
		val startupAction = controllers.map[ ctrl |
			ctrl.controllerElements.filter(CustomAction)
				.filter( action | action.name.equals(ProcessController::startupActionName))
		].flatten.head
		
		// if startView set: create GotoViewAction and add it to startupAction
		if (main?.startView != null) {
			val callTask = factory.createCallTask
			val simpleActionRef = factory.createSimpleActionRef
			val gotoViewAction = factory.createGotoViewAction
			callTask.setAction(simpleActionRef)
			simpleActionRef.setAction(gotoViewAction)
			gotoViewAction.setView(main.startView)
			startupAction.codeFragments.add(0, callTask);
		}
		
		// else if startWorkflow set: create SetWorkflowAction and add it to startupAction
		else if (main?.startWorkflow != null) {
			val callTask = factory.createCallTask
			val simpleActionRef = factory.createSimpleActionRef
			val setWorkflowAction = factory.createSetWorkflowAction
			callTask.setAction(simpleActionRef)
			simpleActionRef.setAction(setWorkflowAction)
			setWorkflowAction.setWorkflow(main.startWorkflow)
			startupAction.codeFragments.add(0, callTask);
		}
	}
	
	/**
	 * Calculate an MD5 hash for each SimpleAction and assign it to the parameterSignature attribute of the according
	 * SimpleActions. If all attribute values are equal, the assigned parameter signature is the same as well.
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def calculateParameterSignatureForAllSimpleActions() {
		val simpleActions = controllers.map[ ctrl | 
			ctrl.eAllContents.toIterable.filter(SimpleAction)
		].flatten
		
		for (simpleAction : simpleActions) {
			simpleAction.setParameterSignature(simpleAction.calculateParameterSignatureHash)
		}
	}
	
	/**
	 * In the MD2 language it is allowed to bind a list of actions to a list of events. That is comfortable for the developer, however
	 * for the generation process it is preferable to not have combined statements. Therefore, transform all event binding and unbinding
	 * tasks to multiple tasks that only contain one-to-one mappings. E.g.
	 * <pre>
	 *   bind action myAction1 myAction2 on myEvent1 myEvent2
	 * </pre>
	 * 
	 * is transformed to
	 * <pre>
	 *   bind action myAction1 on myEvent1
	 *   bind action myAction1 on myEvent2
	 *   bind action myAction2 on myEvent1
	 *   bind action myAction2 on myEvent2
	 * </pre>
	 * 
	 * Be aware: Due to the language model the actions and events are still represented by lists. However, each list always contains exactly one
	 * element. So that one can rely on statements such as binding.events.get(0).
	 * 
	 * <p>
	 *   DEPENDENCIES: None
	 * </p>
	 */
	def transformEventBindingAndUnbindingTasksToOneToOneRelations() {
		
		////////////////////////////////////////////////////
		// transform all binding tasks
		////////////////////////////////////////////////////
		
		val bindingTasks = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(EventBindingTask)
		].flatten.toList
		
		for (bindingTask : bindingTasks) {
			val actions = bindingTask.actions
			val events = bindingTask.events
			val codeFragmentContainer = bindingTask.eContainer as ContainsCodeFragments
			val indexOfBindingTask = codeFragmentContainer.codeFragments.indexOf(bindingTask)
			
			for (action : actions) {
				for (event : events) {
					val newBindingTask = factory.createEventBindingTask
					newBindingTask.actions.add(action.copy)
					newBindingTask.events.add(event.copy)
					codeFragmentContainer.codeFragments.add(indexOfBindingTask, newBindingTask)
				}
			}
			bindingTask.remove
		}
		
		
		////////////////////////////////////////////////////
		// transform all unbinding tasks
		////////////////////////////////////////////////////
		
		val unbindingTasks = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(EventUnbindTask)
		].flatten
		
		for (unbindingTask : unbindingTasks) {
			val actions = unbindingTask.actions
			val events = unbindingTask.events
			val codeFragmentContainer = unbindingTask.eContainer as ContainsCodeFragments
			val indexOfUnbindingTask = codeFragmentContainer.codeFragments.indexOf(unbindingTask)
			
			for (action : actions) {
				for (event : events) {
					val newUnbindingTask = factory.createEventUnbindTask
					newUnbindingTask.actions.add(action.copy)
					newUnbindingTask.events.add(event.copy)
					codeFragmentContainer.codeFragments.add(indexOfUnbindingTask, newUnbindingTask)
				}
			}
			unbindingTask.remove
		}
	}
	
	/**
	 * Replace custom validators with standard validator definitions.
	 */
	def replaceCustomValidatorsWithStandardValidatorDefinitions() {
		val Iterable<CustomizedValidatorType> validators = controllers.map[ ctrl |
			ctrl.eAllContents.toIterable.filter(CustomizedValidatorType)
		].flatten
		
		validators.forEach [ validator |
			val customizedValidatorToReplace = validator.validator
			var StandardValidatorType replacement
			
			// Get custom validator and create a standard validator from its information
			var StandardValidator newValidator = switch (customizedValidatorToReplace) {
				NotNullValidator: factory.createStandardNotNullValidator
				RegExValidator: factory.createStandardRegExValidator
				NumberRangeValidator: factory.createStandardNumberRangeValidator
				StringRangeValidator: factory.createStandardStringRangeValidator
				DateRangeValidator: factory.createStandardDateRangeValidator
				TimeRangeValidator: factory.createStandardTimeRangeValidator
				DateTimeRangeValidator: factory.createStandardDateTimeRangeValidator
			}
			
			newValidator.params.addAll(customizedValidatorToReplace.params)
			replacement = factory.createStandardValidatorType
			replacement.validator = newValidator
			validator.replace(replacement)
		]
	}
	
}