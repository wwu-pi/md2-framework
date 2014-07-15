package de.wwu.md2.framework.generator.preprocessor

import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.ContainsCodeFragments
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomizedValidatorType
import de.wwu.md2.framework.mD2.DateRangeValidator
import de.wwu.md2.framework.mD2.DateTimeRangeValidator
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.Main
import de.wwu.md2.framework.mD2.NotNullValidator
import de.wwu.md2.framework.mD2.NumberRangeValidator
import de.wwu.md2.framework.mD2.RegExValidator
import de.wwu.md2.framework.mD2.SimpleAction
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
import de.wwu.md2.framework.mD2.StringRangeValidator
import de.wwu.md2.framework.mD2.TimeRangeValidator
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension de.wwu.md2.framework.generator.preprocessor.util.Util.*
import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import de.wwu.md2.framework.mD2.ContentProviderimport de.wwu.md2.framework.mD2.CustomAction

class ProcessController {
	
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
	def static void createStartUpActionAndRegisterAsOnInitializedEvent(MD2Factory factory, ResourceSet workingInput) {
		
		val ctrl = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		if (ctrl != null) {
			
			// create __startupAction
			val startupAction = factory.createCustomAction();
			startupAction.setName(startupActionName)
			ctrl.controllerElements.add(startupAction)
			
			// register __startupAction as onInitializedEvent in main block
			val main = ctrl.eAllContents.toIterable.filter(typeof(Main)).last
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
	def static void replaceDefaultProviderTypeWithConcreteDefinition(MD2Factory factory, ResourceSet workingInput) {
		val contentProviders = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(ContentProvider))
		].flatten
		
		val main = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Main))
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
	def static void replaceCombinedActionWithCustomAction(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<CombinedAction> combinedActions = workingInput.resources.map[ r | 
			r.allContents.toIterable.filter(typeof(CombinedAction))
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
	 * the view that is defined in the controller's main block. If no startView is specified, no GotoViewAction will be
	 * created.
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
	def static void createInitialGotoViewAction(MD2Factory factory, ResourceSet workingInput) {
		
		val main = workingInput.resources.map[ r | 
			r.allContents.toIterable.filter(typeof(Main))
		].flatten.head
		
		val startupAction = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(CustomAction))
				.filter( action | action.name.equals(ProcessController::startupActionName))
		].flatten.last
		
		// create GotoViewAction and add it to startupAction
		if (main?.startView != null) {
			val callTask = factory.createCallTask
			val simpleActionRef = factory.createSimpleActionRef
			val gotoViewAction = factory.createGotoViewAction
			callTask.setAction(simpleActionRef)
			simpleActionRef.setAction(gotoViewAction)
			gotoViewAction.setView(main.startView)
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
	def static void calculateParameterSignatureForAllSimpleActions(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<SimpleAction> simpleActions = workingInput.resources.map[ r | 
			r.allContents.toIterable.filter(typeof(SimpleAction))
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
	def static void transformEventBindingAndUnbindingTasksToOneToOneRelations(MD2Factory factory, ResourceSet workingInput) {
		
		////////////////////////////////////////////////////
		// transform all binding tasks
		////////////////////////////////////////////////////
		
		val bindingTasks = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(EventBindingTask))
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
		
		val unbindingTasks = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(EventUnbindTask))
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
	def static void replaceCustomValidatorsWithStandardValidatorDefinitions(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<CustomizedValidatorType> validators = workingInput.resources.map[r |
			r.allContents.toIterable.filter(typeof(CustomizedValidatorType))
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