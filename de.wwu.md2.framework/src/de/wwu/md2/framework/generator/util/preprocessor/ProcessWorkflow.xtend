package de.wwu.md2.framework.generator.util.preprocessor

import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.GotoWorkflowStepAction
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.Model
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowStep
import org.eclipse.emf.ecore.resource.ResourceSet

import static extension de.wwu.md2.framework.generator.util.preprocessor.Util.*
import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.EventDef
import de.wwu.md2.framework.mD2.ViewElementEventRef
import de.wwu.md2.framework.mD2.ContentProviderEventRef
import de.wwu.md2.framework.mD2.GlobalEventRef
import de.wwu.md2.framework.mD2.ConditionalEventRef
import de.wwu.md2.framework.mD2.LocationProvider
import de.wwu.md2.framework.mD2.ContentProviderPathDefinition
import de.wwu.md2.framework.mD2.View
import de.wwu.md2.framework.mD2.ViewGUIElement

class ProcessWorkflow {
	
	////////////////////////////////////////////////
	// Workflow Transformation Methods
	////////////////////////////////////////////////
	
	def static void transformWorkflowsToSequenceOfCoreLanguageElements(MD2Factory factory, ResourceSet workingInput) {
		val controllerStateEntity = createWorkflowControllerStateEntity(factory, workingInput)
		val controllerStateCP = createWorkflowControllerStateContentProvider(factory, workingInput, controllerStateEntity)
	}
	
	/**
	 * Create entity that stores the current state of the workflow and populate it with the required attributes
	 * <code>currentWorkflowStep : STRING</code> and <code>lastEventFired : STRING</code>. <code>currentWorkflowStep</code>
	 * stores the current workflow name and stepname in the form <i>workflow__step</i>. <code>lastEventFired</code> always keeps
	 * the name of the last event that was fired (should be the event that triggered the <code>__WorkflowProcessAction</code>).
	 */
	def private static createWorkflowControllerStateEntity(MD2Factory factory, ResourceSet workingInput) {
		val model = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Model))
		].flatten.last
		
		// Create entity
		val controllerStateEntity = factory.createEntity
		controllerStateEntity.setName("__WorkflowControllerState")
		
		{
			// Add attribute => currentWorkflowStep : STRING
			val attribute = factory.createAttribute
			val stringType = factory.createStringType
			attribute.setName("currentWorkflowStep")
			attribute.setType(stringType)
			controllerStateEntity.attributes.add(attribute)
		}
		
		{
			// Add attribute => lastEventFired : STRING
			val attribute = factory.createAttribute
			val stringType = factory.createStringType
			attribute.setName("lastEventFired")
			attribute.setType(stringType)
			controllerStateEntity.attributes.add(attribute)
		}
		
		model.modelElements.add(controllerStateEntity)
		
		return controllerStateEntity
	}
	
	/**
	 * Create content provider for <code>__WorkflowControllerState</code> entity.
	 */
	def private static createWorkflowControllerStateContentProvider(MD2Factory factory, ResourceSet workingInput, Entity controllerStateEntity) {
		val controller = workingInput.resources.map[ r |
			r.allContents.toIterable.filter(typeof(Controller))
		].flatten.last
		
		val referencedModelType = factory.createReferencedModelType
		referencedModelType.setEntity(controllerStateEntity)
		
		val contentProvider = factory.createContentProvider
		contentProvider.setName("__workflowControllerStateProvider")
		contentProvider.setLocal(true)
		contentProvider.setType(referencedModelType)
		
		controller.controllerElements.add(contentProvider)
		
		return contentProvider
	}
	
	def private static void createWorkflowProcessAction(MD2Factory factory, ResourceSet workingInput) {
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
				
				// Create ifCodeBlock with condition
				val ifCodeBlock = factory.createIfCodeBlock
				
				val condition = factory.createCondition
				val conditionalExpression = factory.createEqualsExpression
				condition.subConditions.add(conditionalExpression)
				
				// eqLeft composition
				val contentProviderPathDefinition = factory.createContentProviderPathDefinition
				val pathTail = factory.createPathTail
				pathTail.setAttributeRef(mappingEntity.attributes.filter( a | a.name.equals(identifier)).last)
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
				
				mappingIfBlock.setCondition(mappingCondition)
				mappingCodeFragment.setIf(mappingIfBlock)
				eventConditionIfBlock.codeFragments.add(mappingCodeFragment)
				
				
				// add ifCodeBlock => first element if(...); all other elements elseif(...)
				if(wfIndex + stepIndex == 0) {
					conditionalCodeFragment.setIf(ifCodeBlock)
				} else {
					conditionalCodeFragment.elseifs.add(ifCodeBlock)
				}
			]
		]
	}
	
	def private static void createWorkflowActionTriggerEvents(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	def private static void createActionsToAssoziateWithTheEvents(MD2Factory factory, ResourceSet workingInput) {
		
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
	
	def private static getStringRepresentationOfEvent(EventDef event) {
		switch (event) {
			ViewElementEventRef: {
				var eObject = event.eContainer
				var str = ""
				while (!(eObject instanceof View)) {
					if(eObject instanceof ViewGUIElement) {
						str = "." + (eObject as ViewGUIElement).name + str
					}
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
	
	def private static getStringRepresentationOfStep(WorkflowStep step) {
		val workflow = step.eContainer as Workflow
		return workflow.name + "__" + step.name
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
