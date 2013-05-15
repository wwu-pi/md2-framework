package de.wwu.md2.android.lib.controller.events;

public abstract class AbstractMD2Event {
	
	private MD2EventBus eventBus;
	private String eventName;
	
	public AbstractMD2Event(MD2EventBus eventBus, String eventName) {
		this.eventBus = eventBus;
		this.eventName = eventName;
	}
	
	protected void eventOccured() {
		eventBus.eventOccured(eventName);
	}
	
}
