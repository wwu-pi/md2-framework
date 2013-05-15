package de.wwu.md2.android.lib.controller.events;

import android.view.View;
import android.view.View.OnFocusChangeListener;

public class MD2FocusLeftEvent extends AbstractMD2Event implements OnFocusChangeListener {
	
	public MD2FocusLeftEvent(MD2EventBus eventBus, String eventName) {
		super(eventBus, eventName);
	}
	
	@Override
	public void onFocusChange(View v, boolean hasFocus) {
		if (!hasFocus) {
			eventOccured();
		}
	}
	
}
