package de.wwu.md2.android.lib.controller.binding;

import android.widget.CheckBox;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;

public class CheckBoxMapping<E extends Entity> extends Mapping<E, Boolean> {
	
	public CheckBoxMapping(CheckBox associatedElement, ContentProvider<E> modelContentProvider,
			PathResolver<E, Boolean> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
	}
	
	@Override
	public CheckBox getView() {
		return (CheckBox) super.getView();
	}

	@Override
	protected Boolean getViewValue() {
		return getView().isChecked();
	}
	
	@Override
	protected void setViewValue(Boolean value) {
		getView().setChecked(value);
		
	}
	
}