package de.wwu.md2.android.lib.controller.workflow;

import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.condition.Condition;

public abstract class WorkflowStep {
	private final String stepName;
	private final Condition forwardCondition;
	private final Condition backwardCondition;
	protected final MD2Application application;
	
	public WorkflowStep(String stepName, MD2Application application) {
		this.stepName = stepName;
		this.application = application;
		
		forwardCondition = getInitilizedForwardConditions();
		backwardCondition = getInitilizedBackwardConditions();
	}
	
	public String getName() {
		return stepName;
	}
	
	public abstract String getViewName();
	
	public abstract String getViewTitle();
	
	protected abstract Condition getInitilizedForwardConditions();
	
	public abstract String getForwardMessage();
	
	protected abstract Condition getInitilizedBackwardConditions();
	
	public abstract String getBackwardMessage();
	
	protected abstract void registerEventhandler();
	
	protected abstract void unregisterEventhandler();
	
	protected abstract void showView();
	
	public boolean isStepForwardsAllowed() {
		return forwardCondition == null || forwardCondition.checkCondition();
	}
	
	public boolean isStepBackwardsAllowed() {
		return backwardCondition == null || backwardCondition.checkCondition();
	}
	
	public void activate() {
		registerEventhandler();
		showView();
	}
	
	public void deactivate() {
		unregisterEventhandler();
	}
	
}
