package de.wwu.md2.android.lib.controller.events;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MD2TouchEvent extends AbstractMD2Event implements OnClickListener {
	
	public MD2TouchEvent(MD2EventBus eventBus, String eventName) {
		super(eventBus, eventName);
	}

	@Override
	public void onClick(View view) {
		// If the clicked view is a button, request focus, so that the last focused element will lose focus and fire a respective event
		if(view instanceof Button) {
			view.requestFocusFromTouch();
		}
		
		eventOccured();
	}
	
}
