package de.wwu.md2.framework.validation

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AllowedOperation
import de.wwu.md2.framework.mD2.AttributeSetTask
import de.wwu.md2.framework.mD2.CompareExpression
import de.wwu.md2.framework.mD2.ContentProviderOperationAction
import de.wwu.md2.framework.mD2.ContentProviderReference
import de.wwu.md2.framework.mD2.ContentProviderSetTask
import de.wwu.md2.framework.mD2.LocationProviderReference
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.MappingTask
import de.wwu.md2.framework.mD2.Operator
import de.wwu.md2.framework.mD2.UnmappingTask
import de.wwu.md2.framework.mD2.ViewElementSetTask
import de.wwu.md2.framework.mD2.WhereClauseCompareExpression
import de.wwu.md2.framework.mD2.ProcessChain
import de.wwu.md2.framework.mD2.ProcessChainGoToNext
import de.wwu.md2.framework.mD2.ProcessChainGoToPrevious
import de.wwu.md2.framework.mD2.ProcessChainStep
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

import static extension de.wwu.md2.framework.validation.TypeResolver.*
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.util.GetFiredEventsHelper
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.SimpleActionRef
import de.wwu.md2.framework.mD2.FireEventAction

/**
 * Valaidators for all controller elements of MD2.
 */
class ControllerValidator extends AbstractMD2JavaValidator {
	
	@Inject
    override register(EValidatorRegistrar registrar) {
        // nothing to do
    }
    
    public static final String EMPTYPROCESSCHAIN = "emptyProcessChain";
    
    @Inject
    GetFiredEventsHelper helper;
    
    /////////////////////////////////////////////////////////
	/// Action Validators
	/////////////////////////////////////////////////////////
	
	public static final String EVENTININIT = "EventInInitBlock"
	
	/**
	 * Throws errors if a WorkflowEvent is fired in the init Block of a WorkflowElement.
	 */
	@Check
	def checkNoFireEventActionInInitBlock(WorkflowElement wfe){
		val initActions = wfe.initActions.filter(CustomAction).map[it.codeFragments].flatten
		
		val bindActions = initActions.filter(EventBindingTask).map[it.actions].flatten
		val unbindActions = initActions.filter(EventUnbindTask).map[it.actions].flatten
		val callActions = initActions.filter(CallTask).map[it.action]
		
		val allActions = bindActions + unbindActions + callActions
		val fireEventActions = allActions.filter(SimpleActionRef).map[it.action].filter(FireEventAction)
		
		fireEventActions.forEach[
			acceptError(it.workflowEvent.name + ": Workflow events must not be fired inside the onInit block!", it, MD2Package.eINSTANCE.fireEventAction_WorkflowEvent , -1, EVENTININIT)
		]
		
	}
	/**
	 * Ensures that the operations 'save' and 'remove' can only be used for none-read-only content providers
	 * in the ContentProviderOperationAction.
	 */
	@Check
	def checkOnlyReadParameterForReadOnlyContentProviderOperations(ContentProviderOperationAction action) {
		
		val abstractProviderReference = action.contentProvider
		val isReadOnly = switch (abstractProviderReference) {
			ContentProviderReference: abstractProviderReference.contentProvider.readonly
			LocationProviderReference: true
		}
		
		if (isReadOnly && !action.operation.equals(AllowedOperation::READ)) {
			val error = '''
				You tried to apply a '«action.operation»'-operation on a read-only content provider. Only 'load' is allowed in this location.
			'''
			acceptError(error, action, MD2Package.eINSTANCE.contentProviderOperationAction_Operation, -1, null);
		}
	}
	
	public static final String EVENTSINCONTROLLER = "EventsInController";
	
	/**
	 * For each Workflow Element Entry of a workflow model, this
	 * method checks whether all Workflow Events fired by the corresponding
	 * Workflow Element are handled.
	 */
	@Check
	def checkAllEventsOfWorkflowElementHandled(WorkflowElementEntry workflowElementEntry){
		// get names of all events expected in *Workflow.md2
		val expectedEvents = workflowElementEntry.firedEvents.map[it.event.name]
		
		// get names of all events fired in *Controller.md2
		val actuallyFiredEvents = helper.getFiredEvents(workflowElementEntry.workflowElement).map[
			it.name
		].toSet
		
		// Calculate difference
		val eventsInControllerButNotInWorkflow = actuallyFiredEvents.filter[!expectedEvents.contains(it)]
		
		// Show error
		eventsInControllerButNotInWorkflow.forEach[ eventName |
			error("The event " + eventName + " specified in WorkflowElement is not caught",
				MD2Package.eINSTANCE.workflowElementEntry_WorkflowElement, -1, EVENTSINCONTROLLER
			)
		]
	}
	
	
	/////////////////////////////////////////////////////////
	/// Type Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Ensures that attributes can only be mapped to a view element if both are of the same data type.
	 */
	@Check
	def checkDataTypesOfMappingTask(MappingTask task) {
		val viewFieldType = task.referencedViewField.expressionType
		val attributeType = task.pathDefinition.expressionType
		
		if (!viewFieldType.equals(attributeType)) {
			val error = '''Cannot map an attribute with value of type '«attributeType»' to a view element that handles values of type '«viewFieldType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.mappingTask_PathDefinition, -1, null);
		}
	}
	
	/**
	 * Ensures that attributes can only be unmapped from a view element if both are of the same data type.
	 */
	@Check
	def checkDataTypesOfUnmappingTask(UnmappingTask task) {
		val viewFieldType = task.referencedViewField.expressionType
		val attributeType = task.pathDefinition.expressionType
		
		if (!viewFieldType.equals(attributeType)) {
			val error = '''Cannot map an attribute with value of type '«attributeType»' to a view element that handles values of type '«viewFieldType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.unmappingTask_PathDefinition, -1, null);
		}
	}
	
	/**
	 * Ensures that values can only be set to an attribute if both have the same data type.
	 */
	@Check
	def checkDataTypesOfAttributeSetTask(AttributeSetTask task) {
		val targetType = task.pathDefinition.expressionType
		val sourceType = task.source.expressionType
		val isValidEnum = task.source.isValidEnumType(task.pathDefinition)
		
		if (!targetType.equals(sourceType) && !targetType.equals("string") && !isValidEnum) {
			val error = '''Cannot set value of type '«sourceType»' to attribute with value of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.attributeSetTask_Source, -1, null);
		} else if (!targetType.equals(sourceType) && targetType.equals("string") && !isValidEnum) {
			val warning = '''You are assigning a value of type '«sourceType»' to an attribute of type string. The string representation of '«sourceType»' will be assigned instead.'''
			acceptWarning(warning, task, MD2Package.eINSTANCE.attributeSetTask_Source, -1, null);
		}
	}
	
	/**
	 * Ensures that values can only be set to a content provider if both have the same data type.
	 */
	@Check
	def checkDataTypesOfContentProviderSetTask(ContentProviderSetTask task) {
		val targetType = task.contentProvider.expressionType
		val sourceType = task.source.expressionType
		
		if (!targetType.equals(sourceType)) {
			val error = '''Cannot set value of type '«sourceType»' to content provider of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.contentProviderSetTask_Source, -1, null);
		}
	}
	
	/**
	 * Ensures that values can only be set to a view element if both have the same data type.
	 */
	@Check
	def checkDataTypesOfViewElementSetTask(ViewElementSetTask task) {
		val targetType = task.referencedViewField.expressionType
		val sourceType = task.source.expressionType
		val isValidEnum = task.source.isValidEnumType(task.referencedViewField)
		
		if (!targetType.equals(sourceType) && !targetType.equals("string") && !isValidEnum) {
			val error = '''Cannot set value of type '«sourceType»' to a view element that handles values of type '«targetType»'.'''
			acceptError(error, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		} else if (!targetType.equals(sourceType) && targetType.equals("string") && !isValidEnum) {
			val warning = '''You are assigning a value of type '«sourceType»' to view element of type string. The string representation of '«sourceType»' will be assigned instead.'''
			acceptWarning(warning, task, MD2Package.eINSTANCE.viewElementSetTask_Source, -1, null);
		}
	}
	
	/**
	 * Ensures that the left-hand side and the right-hand side of a comparison expression have the same data type.
	 */
	@Check
	def checkBothExpressionsInComparisonOfSameType(CompareExpression expr) {
		val left = expr.eqLeft.expressionType
		val right = expr.eqRight.expressionType
		val isValidEnum = expr.eqLeft.isValidEnumType(expr.eqRight)
		
		if (!left.equals(right) && !isValidEnum) {
			val error = '''Cannot compare a value of type '«right»' with a value of type '«left»'. Both values in a comparison have to be of the same type.'''
			acceptError(error, expr, MD2Package.eINSTANCE.compareExpression_EqRight, -1, null);
		}
	}
	
	/**
	 * Ensures that <=, >=, < and > can only be applied to values with numerical values.
	 */
	@Check
	def checkCorrectUsageOfOperators(CompareExpression expr) {
		val left = expr.eqLeft.expressionType
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}
		val numericTypes = newHashSet("integer", "float", "date", "time", "datetime")
		
		if (isNumericOperator && !numericTypes.contains(left)) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.compareExpression_Op, -1, null);
		}
	}
	
	/**
	 * Ensures that the left-hand side (attribute value) and the right-hand side of a where filter comparison expression
	 * have the same data type.
	 */
	@Check
	def checkBothExpressionsInWhereClauseComparisonOfSameType(WhereClauseCompareExpression expr) {
		val attrType = expr.eqLeft.tail.resolveAttribute.attributeTypeName
		val valueType = expr.eqRight.expressionType
		
		if (!attrType.equals(valueType)) {
			val error = '''Cannot compare a value of type '«valueType»' with an attribute that has a value of type '«attrType»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.whereClauseCompareExpression_EqRight, -1, null);
		}
	}
	
	/**
	 * Ensures that <=, >=, < and > can only be applied to values with numerical values.
	 */
	@Check
	def checkCorrectUsageOfOperatorsInWhereClauseComparison(WhereClauseCompareExpression expr) {
		val left = expr.eqLeft.tail.resolveAttribute.attributeTypeName
		val isNumericOperator = switch expr.op {
			case Operator::GREATER: true
			case Operator::GREATER_OR_EQUAL: true
			case Operator::SMALLER: true
			case Operator::SMALLER_OR_EQUAL: true
			default: false
		}
		val numericTypes = newHashSet("integer", "float", "date", "time", "datetime")
		
		if (isNumericOperator && !numericTypes.contains(left)) {
			val error = '''Cannot use operator '«expr.op.toString»' on a value of type '«left»'.'''
			acceptError(error, expr, MD2Package.eINSTANCE.whereClauseCompareExpression_Op, -1, null);
		}
	}
	
	
	/////////////////////////////////////////////////////////
	/// ProcessChain Validators
	/////////////////////////////////////////////////////////
	
	/**
	 * Avoids that reverse operations can be assigned to the first step of a ProcessChain.
	 */
	@Check
	def checkThatNoReverseDeclarationsOnFirstProcessChainStep(ProcessChainGoToPrevious reverse) {
		
		val processChainStep = reverse.eContainer.eContainer as ProcessChainStep
		val processChain = processChainStep.eContainer as ProcessChain
		
		val stepIndex = processChain.processChainSteps.indexOf(processChainStep)
		
		if (stepIndex == 0) {
			val error = '''No preceeding step! Cannot define 'reverse' operation on first processChain step.'''
			acceptError(error, reverse, null, -1, null);
		}
	}
	
	/**
	 * Avoids that proceed operations can be assigned to the last step of a ProcessChain.
	 */
	@Check
	def checkThatNoProceedDeclarationsOnLastProcessChainStep(ProcessChainGoToNext next) {
		
		val processChainStep = next.eContainer.eContainer as ProcessChainStep
		val processChain = processChainStep.eContainer as ProcessChain
		
		val stepIndex = processChain.processChainSteps.indexOf(processChainStep)
		
		if (stepIndex == processChain.processChainSteps.size - 1) {
			val error = '''No subsequent step! Cannot define 'proceed' operation on last processChain step.'''
			acceptError(error, next, null, -1, null);
		}
	}
	
	/**
     * Avoid empty processChains.
     * @param processChain
     */
    @Check
    def checkForEmptyProcessChains(ProcessChain processChain) {
        if(processChain.processChainSteps.empty) {
            acceptWarning("No processChain steps are defined for this processChain. A processChain should have at least one step showing a view.",
                    processChain, null, -1, EMPTYPROCESSCHAIN);
        }
    }
	
}
