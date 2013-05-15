package de.wwu.md2.android.lib.controller.validators;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;

public class IsIntValidator extends AbstractValidator {
	
	public IsIntValidator(String message, TextView view, MD2Application app, String viewName) {
		super(message, view, app, viewName);
	}
	
	@Override
	protected String getDefaultMessage() {
		return "You have to enter an integer!";
	}
	
	@Override
	protected boolean validate(String value) {
		try {
			if (value == null || value.length() == 0) {
				return true;
			}
			Integer.parseInt(value);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}
	
}
