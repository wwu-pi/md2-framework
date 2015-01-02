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
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.SetProcessChainAction

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
	def createStartUpActionAndRegisterAsOnInitializedEvent(WorkflowElement wfe) {
		// create __startupAction
		val startupAction = factory.createCustomAction;
		startupAction.setName(startupActionName)
		wfe.actions.add(startupAction)
		
		// register __startupAction as init action in workflow element
		var initActions = wfe.initActions.copyAll	
		wfe.initActions.clear		
		wfe.initActions += startupAction
		
		// add original startup actions to __startupAction
		initActions.forEach[initAction | 
			val originalCallTask = factory.createCallTask
			val originalActionReference = factory.createActionReference
			originalActionReference.setActionRef(initAction)
			originalCallTask.setAction(originalActionReference)
			startupAction.codeFragments.add(originalCallTask);
		]
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
		val contentProviders = controller.controllerElements.filter(ContentProvider)
		
		val main = controller.controllerElements.filter(Main).head
		
		var remoteConnection = main.defaultConnection
		
		for (contentProvider : contentProviders) {
			if (contentProvider.^default && remoteConnection == null) {
				contentProvider.setLocal(true)
			} else if (contentProvider.^default && remoteConnection != null) {
				contentProvider.setConnection(remoteConnection)
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
	def replaceCombinedActionWithCustomAction(WorkflowElement wfe) {
		// TODO: wfe changes
		val combinedActions = wfe.eAllContents.filter(CombinedAction)
		
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
	 * the view that is defined in the controller's main block. If no startView is specified, a SetProcessChain action
	 * for the startProcessChain is created instead and added to the <i>__startupAction</i> action. Beware that the
	 * SetProcessChainAction is replaced in the workflow processing again as it is no core MD2 element.
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
	def setInitialProcessChainAction(WorkflowElement wfe) {
		
		//TODO: code fragment in comment can be totally removed when DSL is changed 
		//-> we probably only need one initAction per workflow element
		//val startupAction = wfe.eAllContents.filter(CustomAction)
		//		.filter( action | action.name.equals(ProcessController::startupActionName))

		val initAction = wfe.initActions.filter(CustomAction).head
		
		if (wfe.defaultProcessChain != null)
		{
			val callTask = factory.createCallTask
			val simpleActionRef = factory.createSimpleActionRef
			val setProcessChainAction = factory.createSetProcessChainAction
			callTask.setAction(simpleActionRef)
			simpleActionRef.setAction(setProcessChainAction)
			setProcessChainAction.setProcessChain(wfe.defaultProcessChain)
			initAction.codeFragments.add(0, callTask);
			wfe.setDefaultProcessChain(null)
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
	def calculateParameterSignatureForAllSimpleActions(WorkflowElement wfe) {
		
		val simpleActions = wfe.eAllContents.toIterable.filter(SimpleAction).toList
				
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
	def transformEventBindingAndUnbindingTasksToOneToOneRelations(WorkflowElement wfe) {
		
		////////////////////////////////////////////////////
		// transform all binding tasks
		////////////////////////////////////////////////////
		
		var bindingTasks = wfe.eAllContents.toIterable.filter(EventBindingTask).toList
	
		
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
		
		val unbindingTasks = wfe.eAllContents.toIterable.filter(EventUnbindTask).toList
		
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
	    
	    val Iterable<CustomizedValidatorType> validators = controller.eAllContents.toIterable.filter(CustomizedValidatorType)
		
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