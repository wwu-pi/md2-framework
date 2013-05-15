package de.wwu.md2.android.lib.controller.workflow;

import java.util.ArrayList;
import java.util.List;

import de.wwu.md2.android.lib.MD2Application;

public abstract class Workflow {
	private final List<WorkflowStep> steps;
	private WorkflowStep currentStep;
	
	public Workflow(MD2Application application) {
		steps = new ArrayList<WorkflowStep>();
		
		initializeWorkflowSteps(application);
	}
	
	protected abstract void initializeWorkflowSteps(MD2Application application);
	
	protected void addWorkflowStep(WorkflowStep step) {
		steps.add(step);
	}
	
	public void activate() {
		currentStep = steps.get(0);
		currentStep.activate();
	}
	
	public void deactivate() {
		currentStep = null;
		currentStep.deactivate();
	}
	
	public String goToNextStep() {
		if (currentStep.isStepForwardsAllowed()) {
			int nextStepNumber = steps.indexOf(currentStep) + 1;
			if (nextStepNumber < steps.size()) {
				changeCurrentStep(nextStepNumber);
				return null;
			} else {
				return getStepOutOfRangeErrorMessage();
			}
		} else {
			return buildErrorMessage(currentStep.getViewTitle(), currentStep.getForwardMessage());
		}
	}
	
	public String goToPreviousStep() {
		if (currentStep.isStepBackwardsAllowed()) {
			int nextStepNumber = steps.indexOf(currentStep) - 1;
			if (nextStepNumber >= 0) {
				changeCurrentStep(nextStepNumber);
				return null;
			} else {
				return getStepOutOfRangeErrorMessage();
			}
		} else {
			return buildErrorMessage(currentStep.getViewTitle(), currentStep.getBackwardMessage());
		}
	}
	
	public String goToStep(String stepName) {
		return goToStep(getStepIndexByStepName(stepName));
	}
	
	public String goToStepByViewName(String viewName) {
		return goToStep(getStepIndexByViewName(viewName));
	}
	
	private String goToStep(int targetSteNumber) {
		int currentStepNumber = steps.indexOf(currentStep);
		if (targetSteNumber >= 0 && targetSteNumber < steps.size()) {
			if (currentStepNumber < targetSteNumber) {
				for (int i = currentStepNumber; i < targetSteNumber; i++) {
					if (!steps.get(i).isStepForwardsAllowed()) {
						return buildErrorMessage(steps.get(i).getViewTitle(), steps.get(i).getForwardMessage());
					}
				}
			} else if (currentStepNumber > targetSteNumber) {
				for (int i = currentStepNumber; i > targetSteNumber; i--) {
					if (!steps.get(i).isStepBackwardsAllowed()) {
						return buildErrorMessage(steps.get(i).getViewTitle(), steps.get(i).getBackwardMessage());
					}
				}
			}
			changeCurrentStep(targetSteNumber);
			return null;
		}
		return getStepOutOfRangeErrorMessage();
	}
	
	private int getStepIndexByStepName(String stepName) {
		for (int i = 0; i < steps.size(); i++) {
			if (steps.get(i).getName().equals(stepName)) {
				return i;
			}
		}
		return -1;
	}
	
	private int getStepIndexByViewName(String viewName) {
		for (int i = 0; i < steps.size(); i++) {
			if (steps.get(i).getViewName().equals(viewName)) {
				return i;
			}
		}
		return -1;
	}
	
	private void changeCurrentStep(int newStepNumber) {
		currentStep.deactivate();
		currentStep = steps.get(newStepNumber);
		currentStep.activate();
	}
	
	public boolean isStepContained(String stepName) {
		for (WorkflowStep step : steps) {
			if (step.getName().equals(stepName)) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isViewContained(String viewName) {
		for (WorkflowStep step : steps) {
			if (step.getViewName().equals(viewName)) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isViewOfCurrentStep(String viewName) {
		return currentStep.getViewName().equals(viewName);
	}
	
	private String getStepOutOfRangeErrorMessage() {
		return "The workflow step change is not possible, because the target step is not in the specified range.";
	}
	
	private String buildErrorMessage(String viewTitle, String message) {
		String errorMessage = "It is not allowed to go to this workflow step.\nPlease check the view " + viewTitle
				+ ":\n";
		if (message != null) {
			errorMessage += message;
		} else {
			errorMessage += "Not all conditions are fullfilled.";
		}
		return errorMessage;
	}
}
