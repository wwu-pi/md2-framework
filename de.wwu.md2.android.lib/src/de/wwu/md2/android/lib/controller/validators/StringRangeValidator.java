package de.wwu.md2.android.lib.controller.validators;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;

public class StringRangeValidator extends RegExValidator {
	
	private final Integer minLength;
	private final Integer maxLength;
	
	public StringRangeValidator(String message, TextView view, MD2Application app, String viewName, Integer minLength, Integer maxLength) {
		super(message, view, app, viewName, getRegEx(minLength, maxLength));
		this.minLength = minLength;
		this.maxLength = maxLength;

	}
	private static String getRegEx(Integer minLength, Integer maxLength) {
		if (minLength == null && maxLength == null) {
			throw new IllegalArgumentException();
		}
		String regEx;
		if (minLength == null) {
			regEx = ".{0,"+maxLength+"}";
		} else if (maxLength == null) {
			regEx = ".{"+minLength+",}";
		} else {
			regEx = ".{"+minLength+","+maxLength+"}";
		}
		return regEx;
	}
	
	@Override
	protected String getDefaultMessage() {
		if (minLength != null && maxLength != null) {
			return "The entered value needs to be "+minLength+"-"+maxLength+" characters long!";			
		} else if (minLength != null) {
			return "The entered value needs to be at least "+minLength+" characters long!";
		} else {
			return "The entered value needs to be maximal "+maxLength+" characters long!";			
		}
	}
	
}
