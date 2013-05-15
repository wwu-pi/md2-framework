package de.wwu.md2.android.lib.controller.binding;

import android.widget.TextView;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;

public class StringTextViewMapping<E extends Entity> extends AbstractTextViewMapping<E, String> {
	
	public StringTextViewMapping(TextView associatedElement, ContentProvider<E> modelContentProvider, PathResolver<E, String> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
	}
	
	@Override
	protected String getViewValue() {
		return getView().getText().toString();
	}
	
}
