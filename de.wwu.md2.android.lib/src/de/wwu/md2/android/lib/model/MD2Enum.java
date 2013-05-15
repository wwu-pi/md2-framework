package de.wwu.md2.android.lib.model;

import org.codehaus.jackson.annotate.JsonIgnore;

import android.content.Context;
import android.content.res.Resources.NotFoundException;

/**
 * Wrapps string array to use them as enum-style data containers in entity
 * classes.
 * 
 */
public abstract class MD2Enum {
	private int selectedIdx = -1;
	
	@JsonIgnore
	public abstract int getResourceId();
	
	public MD2Enum() {
		
	}
	
	public MD2Enum(int selectedIndex) {
		this.selectedIdx = selectedIndex;
	}
	
	public String[] getValues(Context context) {
		try {
			return context.getResources().getStringArray(getResourceId());
		} catch (NotFoundException e) {
			return new String[0];
		}
	}
	
	public int getSelectedIdx() {
		return selectedIdx;
	}
	
	public void setSelectedIdx(int selectedIdx) {
		this.selectedIdx = selectedIdx;
	}
}
