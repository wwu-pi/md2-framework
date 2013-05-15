package de.wwu.md2.android.lib.controller.actions;

import de.wwu.md2.android.lib.MD2Application;

public interface CodeFragment {
	
	String getActivityName();
	
	void execute(MD2Application app);
	
}
