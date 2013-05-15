package de.wwu.md2.android.lib.controller.actions;

import java.util.LinkedList;
import java.util.List;

import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;

public abstract class CustomAction implements MD2EventHandler, Action {
	
	private MD2Application application;
	private List<CodeFragment> codeFragments;
	
	public CustomAction(MD2Application application) {
		this.application = application;
		codeFragments = new LinkedList<CodeFragment>();
		
		initializeCodeFragments();
	}
	
	protected void addCodeFragment(CodeFragment codeFragment) {
		codeFragments.add(codeFragment);
	}
	
	protected abstract void initializeCodeFragments();

	@Override
	public void execute() {
		for (CodeFragment codeFragment : codeFragments) {
			if(codeFragment.getActivityName() == null || codeFragment.getActivityName().equals(application.getActiveActivityName())) {
				codeFragment.execute(application);
			}
			else {
				application.enqueueCodeFragment(codeFragment);
			}
		}
	}

	@Override
	public void eventOccured() {
		execute();
	}

}
