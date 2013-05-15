package de.wwu.md2.android.lib.controller.events;

import android.view.View;
import android.widget.AdapterView;

public class MD2ItemSelectedEvent extends AbstractMD2Event implements AdapterView.OnItemSelectedListener {
	
	public MD2ItemSelectedEvent(MD2EventBus eventBus, String eventName) {
		super(eventBus, eventName);
	}
	
	@Override
	public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
		eventOccured();
	}
	
	@Override
	public void onNothingSelected(AdapterView<?> parent) {
		eventOccured();
	}
	
}
