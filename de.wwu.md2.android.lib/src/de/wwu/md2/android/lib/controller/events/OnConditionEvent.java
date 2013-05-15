package de.wwu.md2.android.lib.controller.events;

import java.util.Map;

import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Spinner;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.condition.Condition;

public class OnConditionEvent extends AbstractMD2Event implements MD2EventHandler {
	
	private Condition condition;
	private MD2Application app;
	private String name;
	
	public OnConditionEvent(String name, Condition condition, MD2Application app) {
		super(app.getEventBus(), name + "_OnConditionEvent");
		
		this.name = name;
		this.condition = condition;
		this.app = app;
		
		// Listen to change events of all relevant elements
		for (String viewName : condition.getContentElements()) {
			registerEventHandler(viewName);
		}
		
		for (Map.Entry<Integer, String> viewGroupEntry : condition.getContainerElements().entrySet()) {
			registerGetViewEventHandlers(viewGroupEntry);
		}
	}
	
	private void registerGetViewEventHandlers(Map.Entry<Integer, String> viewGroupEntry) {
		final String eventName = viewGroupEntry.getValue() + "_Activated";
		final int viewID = viewGroupEntry.getKey();
		
		app.getEventBus().subscribe(eventName, eventName + "_" + name + "_GetView", new MD2EventHandler() {
			
			@Override
			public void eventOccured() {
				registerEventHandler((ViewGroup) app.getActiveActivity().findViewById(viewID));
				app.getEventBus().unsubscribe(eventName, eventName + "_" + name + "_GetView");
			}
			
		});
	}
	
	private void registerEventHandler(ViewGroup viewGroup) {
		for (int i = 0; i < viewGroup.getChildCount(); i++) {
			View child = viewGroup.getChildAt(i);
			if (child instanceof ViewGroup) {
				registerEventHandler((ViewGroup) child);
			} else if (child instanceof EditText || child instanceof Spinner || child instanceof CheckBox) {
				registerEventHandler(viewGroup.getResources().getResourceEntryName(child.getId()));
			}
		}
	}
	
	private void registerEventHandler(String viewName) {
		app.getEventBus().subscribe(viewName + "_FocusLeft", viewName + "_FocusLeft_" + name, this);
	}
	
	@Override
	public void eventOccured() {
		if (condition.checkCondition()) {
			super.eventOccured();
		}
	}
	
}
