package de.wwu.md2.android.lib.view;

import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;

public class MessageBoxFragment extends DialogFragment {
	
	private String message;
	private MD2EventHandler handler;
	
	public MessageBoxFragment(String message) {
		this.message = message;
	}
	
	public MessageBoxFragment(String message, MD2EventHandler handler) {
		this(message);
		this.handler = handler;
	}
	
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		// Alert dialog builder
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());
		alertDialogBuilder.setMessage(message);
		if (handler == null) {
			alertDialogBuilder.setNegativeButton("Ok", null);
		} else {
			alertDialogBuilder.setNegativeButton("Ok", new OnClickListener() {
				
				@Override
				public void onClick(DialogInterface arg0, int arg1) {
					handler.eventOccured();
				}
			});
		}
		
		// Return the created alert dialog
		return alertDialogBuilder.create();
	}
}
