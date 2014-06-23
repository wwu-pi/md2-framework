package de.wwu.md2.framework.generator.util.preprocessor

import de.wwu.md2.framework.mD2.CallTask
import de.wwu.md2.framework.mD2.CustomAction
import de.wwu.md2.framework.mD2.EventBindingTask
import de.wwu.md2.framework.mD2.EventUnbindTask
import de.wwu.md2.framework.mD2.GotoWorkflowStepAction
import de.wwu.md2.framework.mD2.MD2Factory
import de.wwu.md2.framework.mD2.Workflow
import de.wwu.md2.framework.mD2.WorkflowStep

import static extension de.wwu.md2.framework.generator.util.preprocessor.Util.*
import org.eclipse.emf.ecore.resource.ResourceSet

class ProcessWorkflow {
	
	def static void transformWorkflowsToSequenceOfCoreLanguageElements(MD2Factory factory, ResourceSet workingInput) {
		
	}
	
	def private static void createWorkflowProcessAction() {
		
	}
	
	def private static void createWorkflowActionTriggerEvents() {
		
	}
	
	def private static void createWorkflowControllerEntity() {
		
	}
	
	def private static void createWorkflowControllerContentProvider() {
		
	}
	
	
	////////////////////////////////////////////////
	// Helper methods
	////////////////////////////////////////////////
	
	def private static void getStringRepresentationOfEvent() {
		
	}
	
	def private static void getStringRepresentationOfStep() {
		
	}
	
	
	
	////////////////////////////////////////////////
	// Subworkflow merging
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
