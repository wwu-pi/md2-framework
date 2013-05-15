package de.wwu.md2.android.lib;

import android.app.ActionBar.Tab;
import android.app.ActionBar.TabListener;
import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
import de.wwu.md2.android.lib.view.TabbedActivity;

/**
 * Manages instantiation and attaching/detaching of a fragment to an activity on
 * an action bar press.
 * 
 * @param <T>
 */
public class ChangeTabListener<T extends Fragment> implements TabListener, MD2EventHandler {
	private Fragment mFragment;
	private final MD2Application mApp;
	private final Activity mActivity;
	private final String mTag;
	private final Class<T> mClass;
	private final String mViewName;
	private TabbedActivity mTabHost;
	
	/**
	 * Constructor used each time a new tab is created.
	 * 
	 * @param activity
	 *            The host Activity, used to instantiate the fragment
	 * @param tag
	 *            The identifier tag for the fragment
	 * @param clz
	 *            The fragment's Class, used to instantiate the fragment
	 */
	public ChangeTabListener(MD2Application app, Activity activity, String tag, Class<T> clz, String viewName,
			TabbedActivity tabHost) {
		mApp = app;
		mActivity = activity;
		mTag = tag;
		mClass = clz;
		mViewName = viewName;
		mTabHost = tabHost;
	}
	
	public void onTabSelected(Tab tab, FragmentTransaction ft) {
		// Check if the tab is not contained in the active workflow or is
		// defined by the current step (the go to step has to be done here,
		// because the contained showView has no effect since the tab to show is
		// already selected and therefore this event handler will not be called
		// again. Additionally it returns, whether the tab change is allowed. In
		// case the tab change will be forbidden, an event handler is passed, to
		// show the previously selected tab)
		if (!mApp.getWorkflowManager().isViewContained(mViewName)
				|| mApp.getWorkflowManager().isViewOfCurrentStep(mViewName)
				|| mApp.getWorkflowManager().goToStepByViewName(mViewName, this)) {
			// Check if the fragment is already initialized
			if (mFragment == null || !mFragment.isAdded()) {
				// If not, instantiate and add it to the activity
				mFragment = Fragment.instantiate(mActivity, mClass.getName());
				ft.add(android.R.id.content, mFragment, mTag);
			} else {
				ft.show(mFragment);
			}
			
			// Notify the tab host of the successful tab change
			mTabHost.tabChanged();
		}
	}
	
	public void onTabUnselected(Tab tab, FragmentTransaction ft) {
		// User selected another tab, hide fragment
		// Check if the fragment is already initialized
		if (mFragment != null && mFragment.isAdded()) {
			ft.hide(mFragment);
		}
	}
	
	public void onTabReselected(Tab tab, FragmentTransaction ft) {
		// User selected the already selected tab. Usually do nothing.
	}
	
	@Override
	public void eventOccured() {
		mTabHost.cancelTabChange();
	}
	
}
