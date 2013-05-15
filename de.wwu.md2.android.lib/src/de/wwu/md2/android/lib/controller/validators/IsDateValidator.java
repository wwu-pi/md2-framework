package de.wwu.md2.android.lib.controller.validators;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.view.DatePickerFragment;

public class IsDateValidator extends AbstractValidator {
	
	private SimpleDateFormat sdf = new SimpleDateFormat(DatePickerFragment.DATE_FORMAT);
	
	public IsDateValidator(String message, TextView view, MD2Application app, String viewName, String format) {
		super(message, view, app, viewName);
		if (format != null && !format.equals("")) {
			try {
				sdf = new SimpleDateFormat(format);
			} catch (IllegalArgumentException illArgEx) {
				illArgEx.printStackTrace();
			}
		}		
	}
	
	@Override
	protected String getDefaultMessage() {
		return "The entered value is not a date! Use pattern: "+sdf.toPattern();
	}
	
	@Override
	protected boolean validate(String value) {
		try {
			if (value == null || value.length() == 0) {
				return true;
			}
			sdf.parse(value);
			return true;
		} catch (ParseException e) {
			return false;
		}
	}
}
