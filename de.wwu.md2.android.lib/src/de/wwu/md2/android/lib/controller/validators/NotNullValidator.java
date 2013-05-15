package de.wwu.md2.android.lib.controller.validators;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;

public class NotNullValidator extends AbstractValidator {
	
	public NotNullValidator(String message, TextView view, MD2Application app, String viewName) {
		super(message, view, app, viewName);
	}
	
	@Override
	protected String getDefaultMessage() {
		return "You have to enter a value!";
	}
	
	@Override
	protected boolean validate(String value) {
		return value != null && value.length() != 0;
	}
	
}
