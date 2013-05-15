package de.wwu.md2.android.lib.controller.events;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class MD2EventBus {
	Map<String, LinkedHashMap<String, MD2EventHandler>> eventBindings;
	
	public MD2EventBus() {
		eventBindings = new HashMap<String, LinkedHashMap<String, MD2EventHandler>>();
	}
	
	public void subscribe(String eventName, String eventHandlerName, MD2EventHandler eventHandler) {
		// Retrieve handlers for specified event
		if (!eventBindings.containsKey(eventName)) {
			eventBindings.put(eventName, new LinkedHashMap<String, MD2EventHandler>());
		}
		
		// Insert new handler
		eventBindings.get(eventName).put(eventHandlerName, eventHandler);
	}
	
	public void unsubscribe(String eventName, String eventHanderName) {
		// Check if event handler is registered
		if (eventBindings.containsKey(eventName)) {
			// Delete subscription
			eventBindings.get(eventName).remove(eventHanderName);
		}
	}
	
	public void eventOccured(String eventName) {
		// Check if any event handler is registered
		if (eventBindings.containsKey(eventName)) {
			Map<String, MD2EventHandler> handlers = eventBindings.get(eventName);
			if (handlers != null) {
				// Call all subscribed event handlers
				// (Copy the list of the handlers, in case any handler wants to unsubscribe)
				for (MD2EventHandler handler : handlers.values().toArray(new MD2EventHandler[0])) {
					handler.eventOccured();
				}
			}
		}
	}
}
