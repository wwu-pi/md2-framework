package de.wwu.md2.android.lib.controller.workflow;

import java.util.HashMap;
import java.util.Map;

import android.app.DialogFragment;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
import de.wwu.md2.android.lib.view.MessageBoxFragment;

public class WorkflowManager {
	private final Map<String, Workflow> workflows;
	private Workflow activeWorkflow;
	private MD2Application app;
	private final MD2EventHandler goToNextStepEventHandler;
	private final MD2EventHandler goToPreviousStepEventHandler;
	
	public WorkflowManager(MD2Application app) {
		this.app = app;
		workflows = new HashMap<String, Workflow>();
		
		goToNextStepEventHandler = new MD2EventHandler() {
			
			@Override
			public void eventOccured() {
				goToNextStep();
			}
		};
		goToPreviousStepEventHandler = new MD2EventHandler() {
			
			@Override
			public void eventOccured() {
				goToPreviousStep();
			}
		};
	}
	
	public MD2EventHandler getGoToNextStepEventHandler() {
		return goToNextStepEventHandler;
	}
	
	public MD2EventHandler getGoToPreviousStepEventHandler() {
		return goToPreviousStepEventHandler;
	}
	
	public void addWorkflow(String workflowID, Workflow workflow) {
		workflows.put(workflowID, workflow);
	}
	
	public void setActiveWorkflow(String workflowName) {
		if (activeWorkflow != null) {
			activeWorkflow.deactivate();
		}
		activeWorkflow = workflows.get(workflowName);
		activeWorkflow.activate();
	}
	
	public boolean goToNextStep() {
		if (activeWorkflow != null) {
			String result = activeWorkflow.goToNextStep();
			if (result == null) {
				return true;
			} else {
				showGoToNotAllowedMessage(result);
				return false;
			}
		} else {
			showGoToNotAllowedMessage(getNoActiveWorkflowMessage());
			return false;
		}
	}
	
	public boolean goToPreviousStep() {
		if (activeWorkflow != null) {
			String result = activeWorkflow.goToPreviousStep();
			if (result == null) {
				return true;
			} else {
				showGoToNotAllowedMessage(result);
				return false;
			}
		} else {
			showGoToNotAllowedMessage(getNoActiveWorkflowMessage());
			return false;
		}
	}
	
	public boolean goToStep(String stepName, boolean silentFail) {
		if (activeWorkflow != null) {
			String result = activeWorkflow.goToStep(stepName);
			if (result == null) {
				return true;
			} else {
				if (!silentFail || activeWorkflow.isStepContained(stepName)) {
					showGoToNotAllowedMessage(result);
				}
				return false;
			}
		} else {
			showGoToNotAllowedMessage(getNoActiveWorkflowMessage());
			return false;
		}
	}
	
	public boolean goToStepByViewName(String viewName) {
		return goToStepByViewName(viewName, null);
	}
	
	/**
	 * Goes to the specified workflow step. If not allowed, a message box will
	 * be shown and afterwards, the submitted handler will be called
	 * 
	 * @param viewName
	 * @param handler
	 *            Event handler that will be called, in case any condition is
	 *            not fulfilled, after the message box has been closed by the
	 *            user.
	 * @return
	 */
	public boolean goToStepByViewName(String viewName, MD2EventHandler handler) {
		if (activeWorkflow != null) {
			String result = activeWorkflow.goToStepByViewName(viewName);
			if (result == null) {
				return true;
			} else {
				showGoToNotAllowedMessage(result, handler);
				return false;
			}
		} else {
			showGoToNotAllowedMessage(getNoActiveWorkflowMessage(), handler);
			return false;
		}
	}
	
	public boolean isViewContained(String viewName) {
		return activeWorkflow != null && activeWorkflow.isViewContained(viewName);
	}
	
	public boolean isViewOfCurrentStep(String viewName) {
		return activeWorkflow != null && activeWorkflow.isViewOfCurrentStep(viewName);
	}
	
	private String getNoActiveWorkflowMessage() {
		return "A workflow step change is currently not possible, because no workflow is active.";
	}
	
	private void showGoToNotAllowedMessage(String message) {
		showGoToNotAllowedMessage(message, null);
	}
	
	private void showGoToNotAllowedMessage(String message, MD2EventHandler handler) {
		DialogFragment newFragment = new MessageBoxFragment(message, handler);
		newFragment.show(app.getActiveActivity().getFragmentManager(), "GoToNotAllowedMessage");
	}
}
