package de.wwu.md2.android.lib.controller.validators;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;

public class NumberRangeValidator extends AbstractValidator {
	
	private final double min;
	private final double max;
	
	public NumberRangeValidator(String message, TextView view, MD2Application app, String viewName, double min, double max) {
		super(message, view, app, viewName);
		this.min = min;
		this.max = max;
	}
	
	@Override
	protected String getDefaultMessage() {
		return "The entered value is not in the specified range!";
	}
	
	@Override
	protected boolean validate(String value) {
		try {
			if (value == null || value.length() == 0) {
				return true;
			}
			double doubleValue = Double.parseDouble(value);
			return (doubleValue >= min) && (doubleValue <= max);
		} catch (NumberFormatException e) {
			return false;
		}
	}
}
