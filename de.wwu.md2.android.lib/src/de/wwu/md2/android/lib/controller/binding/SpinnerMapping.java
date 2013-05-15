package de.wwu.md2.android.lib.controller.binding;

import android.content.Context;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;

public class SpinnerMapping<E extends Entity> extends Mapping<E, Integer> {
	
	private boolean viewInitialized = false;
	private String viewName;
	
	public SpinnerMapping(Spinner associatedElement, ContentProvider<E> modelContentProvider, EnumPathResolver<E> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
		this.viewName = viewName;
	}
	
	@Override
	protected void init() {
		if (!viewInitialized) {
			setSpinnerItems(getView().getContext(), getStringArrayResourceId());
			viewInitialized = true;
		}
	}
	
	@Override
	protected Integer getViewValue() {
		if (getView() != null) return getView().getSelectedItemPosition();
		return -1;
	}

	@Override
	protected void setViewValue(Integer value) {
		if (getView() != null)
		getView().setSelection(value, true);
	}

	/*
	 * Helper
	 */
	
	@Override
	public Spinner getView() {
		return (Spinner) super.getView();
	}

	private void setSpinnerItems(final Context context, final int arrayId) {
		final Spinner s = getView();
		if (s == null) return; 
		
		try {
			// Create an ArrayAdapter using the string array and a default spinner layout
			final ArrayAdapter<CharSequence> adapter = ArrayAdapter
					.createFromResource(context, arrayId,
							android.R.layout.simple_spinner_item);
			// Specify the layout to use when the list of choices appears
			adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			// Apply the adapter to the spinner
			s.setAdapter(adapter);
		} catch (NullPointerException e) {
			Log.w("Array resource not found for: "+viewName, e);
		}
	}
	
	private int getStringArrayResourceId() {
		try {
			return ((EnumPathResolver<E>)getResolver()).getEnum(getEntity()).getResourceId();
		} catch (Exception e) {
		}
		return 0;
	}

}
