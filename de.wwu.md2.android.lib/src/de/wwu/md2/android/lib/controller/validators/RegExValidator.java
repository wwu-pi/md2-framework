package de.wwu.md2.android.lib.controller.validators;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;

public class RegExValidator extends AbstractValidator {
	
	private Pattern pattern = Pattern.compile(".*");
	
	public RegExValidator(String message, TextView view, MD2Application app, String viewName, String regEx) {
		super(message, view, app, viewName);
		try {
			pattern = Pattern.compile(regEx);
		} catch (PatternSyntaxException patternEx) {
			patternEx.printStackTrace();
		}
	}
	
	@Override
	protected String getDefaultMessage() {
		return "The entered value does not mach the pattern: "+pattern.pattern();
	}
	
	@Override
	protected boolean validate(String value) {
		if (value == null || value.length() == 0) {
			return true;
		}
		Matcher matcher = pattern.matcher(value);
		return matcher.matches();		
	}
}
