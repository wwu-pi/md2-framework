package de.wwu.md2.framework.generator.util.preprocessor

import de.wwu.md2.framework.mD2.CombinedAction
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
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

class ProcessController {
	
	/**
	 * Replaces CombinedActions with CustomActions that contain calls to each child action declared in the CombinedAction.
	 * Replaces all references to to the CombinedAction with references to the newly created CustomAction.
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