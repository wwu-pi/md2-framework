package de.wwu.md2.android.lib.controller.validators;

import android.widget.TextView;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;

public abstract class AbstractValidator implements MD2EventHandler {
	
	private String message;
	private TextView view;
	private MD2EventBus eventBus;
	private String eventName;
	
	public AbstractValidator(String message, TextView view, MD2Application app, String viewName) {
		String className = getClass().getSimpleName();
		
		this.message = message;
		this.view = view;
		eventBus = app.getEventBus();
		eventName = viewName + "_" + "WrongValidation";
		
		// Subscribe validator at event bus
		eventBus.subscribe(viewName + "_FocusLeft", viewName + "_FocusLeft_" + className, this);
		
		// Add validator to list of validators
		app.addValidator(view.getId(), this);
	}
	
	private String getMessage() {
		if (message != null && message.length() > 0) {
			return message;
		} else {
			return getDefaultMessage();
		}
	}
	
	protected String getDefaultMessage() {
		return "Validation failed";
	}
	
	public boolean validate() {
		// Just validate if no other validator on that field already detected
		// wrong input (set an error)
		if (view.getError() == null || view.getError().length() == 0) {
			if (!validate(view.getText().toString())) {
				view.setError(getMessage());
				eventBus.eventOccured(eventName);
				return false;
			}
			else {
				return true;
			}
		}
		else {
			return false;
		}
	}
	
	protected abstract boolean validate(String value);
	
	@Override
	public void eventOccured() {
		validate();
	}
}
