package de.wwu.md2.android.lib.view;

public interface TabbedActivity {
	
	void setSelectedTab(String tabName);
	
	void tabChanged();

	void cancelTabChange();
	
}
