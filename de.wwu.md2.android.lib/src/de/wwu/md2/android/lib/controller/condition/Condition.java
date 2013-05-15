package de.wwu.md2.android.lib.controller.condition;

import java.util.List;
import java.util.Map;

import android.view.View;
import android.view.ViewGroup;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.validators.AbstractValidator;

public abstract class Condition {
	
	private MD2Application application;
	
	public Condition(MD2Application application) {
		this.application = application;
	}
	
	public abstract Iterable<String> getContentElements();
	
	/**
	 * Returns a dictionary consisting of the ids and containing activities or fragments of all container elements relevant for this condition
	 * @return Dictionary consisting of ids and activity or fragment names
	 */
	public abstract Map<Integer, String> getContainerElements();
	
	public abstract boolean checkCondition();
	
	protected boolean checkValidity(ViewGroup viewGroup) {
		for (int i = 0; i < viewGroup.getChildCount(); i++) {
			View child = viewGroup.getChildAt(i);
			if (child instanceof ViewGroup) {
				if (!checkValidity((ViewGroup) child)) {
					return false;
				}
			} else {
				if (!checkValidity(child.getId())) {
					return false;
				}
			}
		}
		return true;
	}
	
	protected boolean checkValidity(int viewID) {
		List<AbstractValidator> validators = application.getValidators(viewID);
		if (validators != null) {
			for (AbstractValidator validator : validators) {
				if(!validator.validate()) {
					return false;
				}
			}
		}
		return true;
	}
}