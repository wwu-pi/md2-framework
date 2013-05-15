package de.wwu.md2.android.lib;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

import android.app.Activity;
import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import de.wwu.md2.android.lib.controller.actions.Action;
import de.wwu.md2.android.lib.controller.actions.CodeFragment;
import de.wwu.md2.android.lib.controller.binding.Mapping;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.controller.validators.AbstractValidator;
import de.wwu.md2.android.lib.controller.workflow.WorkflowManager;

public abstract class MD2Application extends Application {
	
	private String activeActivityName;
	private Activity activeActivity;
	private MD2EventBus eventBus;
	private WorkflowManager workflowManager;
	private Set<Mapping<?, ?>> mappings;
	private Set<Action> actions;
	private Map<String, Queue<CodeFragment>> codeFragmentQueues;
	private Map<Integer, List<AbstractValidator>> validators;
	private Set<ContentProvider<?>> contentProviders;
	private Set<String> usedActivities;
	
	private boolean firstActivityLoaded = false;
	
	public MD2Application() {
		initializeAppObject();
	}
	
	public MD2EventBus getEventBus() {
		return eventBus;
	}
	
	public WorkflowManager getWorkflowManager() {
		return workflowManager;
	}
	
	public Set<Mapping<?, ?>> getMappings() {
		return mappings;
	}
	
	public String getActiveActivityName() {
		return activeActivityName;
	}
	
	public Activity getActiveActivity() {
		return activeActivity;
	}
	
	public void setActiveActivity(String activeActivityName, Activity activeActivity) {
		usedActivities.add(activeActivityName);
		
		this.activeActivityName = activeActivityName;
		this.activeActivity = activeActivity;
		
		// Fire an event to broadcast the active activity change
		eventBus.eventOccured(activeActivityName + "_Activated");
		
		// Change active activity logic
		// Get queue related to activated activity (or fragment)
		Queue<CodeFragment> codeFragmentToExecute = codeFragmentQueues.get(activeActivityName);
		if (codeFragmentToExecute != null) {
			// Execute all stored code fragments
			while (!codeFragmentToExecute.isEmpty()) {
				CodeFragment curCodeFragment = codeFragmentToExecute.remove();
				curCodeFragment.execute(this);
			}
		}
		
		// Perform one time initializations, that need the first activity to be
		// loaded
		if (!firstActivityLoaded) {
			registerConnectionLostReceiver();
			firstActivityLoaded = true;
		}
	}
	
	private void registerConnectionLostReceiver() {
		registerReceiver(new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				if (intent.getBooleanExtra(ConnectivityManager.EXTRA_NO_CONNECTIVITY, false)) {
					eventBus.eventOccured("Connection_Lost");
				}
			}
		}, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
	}
	
	public void checkForReinitialization(String activityName) {
		if (usedActivities.contains(activityName)) {
			initializeAppObject();
		}
	}
	
	private void initializeAppObject() {
		initializeMembers();
		bootStrap();
	}
	
	private void initializeMembers() {
		activeActivityName = null;
		activeActivity = null;
		eventBus = new MD2EventBus();
		workflowManager = new WorkflowManager(this);
		mappings = new HashSet<Mapping<?, ?>>();
		actions = new HashSet<Action>();
		codeFragmentQueues = new HashMap<String, Queue<CodeFragment>>();
		validators = new HashMap<Integer, List<AbstractValidator>>();
		contentProviders = new HashSet<ContentProvider<?>>();
		usedActivities = new HashSet<String>();
	}
	
	protected abstract void bootStrap();
	
	public <CP extends ContentProvider<?>> void registerContentProvider(ContentProvider<?> cp) {
		contentProviders.remove(findContentProviderByType(cp.getClass()));
		contentProviders.add(cp);
	}
	
	public <CP extends ContentProvider<?>> CP findContentProviderByType(Class<CP> contentProviderClass) {
		CP contentProvider = null;
		for (ContentProvider<?> candidate : contentProviders) {
			if (contentProviderClass.isInstance(candidate))
				contentProvider = contentProviderClass.cast(candidate);
		}
		return contentProvider;
	}
	
	public List<AbstractValidator> getValidators(int viewID) {
		return validators.get(viewID);
	}
	
	public void addValidator(int viewID, AbstractValidator validator) {
		if (!validators.containsKey(viewID)) {
			validators.put(viewID, new LinkedList<AbstractValidator>());
		}
		
		// Insert new validator
		validators.get(viewID).add(validator);
	}
	
	public void removeValidator(int viewID, AbstractValidator validator) {
		if (validators.containsKey(viewID)) {
			validators.get(viewID).remove(validator);
		}
	}
	
	public <A extends Action> void registerAction(Action action) {
		actions.remove(findActionByType(action.getClass()));
		actions.add(action);
	}
	
	public <A extends Action> void executeAction(Class<A> actionClass) {
		A action = findActionByType(actionClass);
		if (action != null)
			action.execute();
	}
	
	public <A extends Action> A findActionByType(Class<A> actionClass) {
		A action = null;
		for (Action candidate : actions) {
			if (actionClass.isInstance(candidate))
				action = actionClass.cast(candidate);
		}
		return action;
	}
	
	public void enqueueCodeFragment(CodeFragment codeFragment) {
		String activityName = codeFragment.getActivityName();
		Queue<CodeFragment> queue = codeFragmentQueues.get(activityName);
		if (queue == null) {
			queue = new LinkedList<CodeFragment>();
			codeFragmentQueues.put(activityName, queue);
		}
		queue.add(codeFragment);
	}
	
}
