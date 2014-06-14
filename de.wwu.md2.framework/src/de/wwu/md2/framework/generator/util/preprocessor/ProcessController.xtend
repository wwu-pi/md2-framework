package de.wwu.md2.framework.generator.util.preprocessor

import de.wwu.md2.framework.mD2.ActionReference
import de.wwu.md2.framework.mD2.CombinedAction
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomizedValidatorType
import de.wwu.md2.framework.mD2.DateRangeValidator
import de.wwu.md2.framework.mD2.DateTimeRangeValidator
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.NotNullValidator
import de.wwu.md2.framework.mD2.NumberRangeValidator
import de.wwu.md2.framework.mD2.RegExValidator
import de.wwu.md2.framework.mD2.StandardValidator
import de.wwu.md2.framework.mD2.StandardValidatorType
import de.wwu.md2.framework.mD2.StringRangeValidator
import de.wwu.md2.framework.mD2.TimeRangeValidator
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessController {
	
	/**
	 * Replace CombinedAction with CustomAction that contains calls to each of is child tasks.
	 */
	def static void replaceCombinedActionWithCustomAction(MD2Factory factory, ResourceSet workingInput) {
		val Iterable<CombinedAction> combinedActions = workingInput.resources.map(r|r.allContents.toIterable.filter(typeof(CombinedAction))).flatten
		combinedActions.forEach [ combinedAction |
			// Assume structue: Controller -> Action
			val parentController = combinedAction.eContainer as Controller
			val custAction = factory.createCustomAction()
			custAction.name = combinedAction.name
			combinedAction.actions.forEach [ actionRef |
				val callTask =  factory.createCallTask()
				callTask.action = factory.createActionReference()
				(callTask.action as ActionReference).actionRef = actionRef
				custAction.codeFragments.add(callTask)
			]
			parentController.controllerElements.add(custAction)
			//combinedAction.remove()
		]
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