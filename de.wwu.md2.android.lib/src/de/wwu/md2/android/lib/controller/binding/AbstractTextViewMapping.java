package de.wwu.md2.android.lib.controller.binding;

import java.io.Serializable;

import android.widget.TextView;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;

public abstract class AbstractTextViewMapping<E extends Entity, V extends Serializable> extends Mapping<E, V> {
	
	public AbstractTextViewMapping(TextView associatedElement, ContentProvider<E> modelContentProvider,
			PathResolver<E, V> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
	}
	
	@Override
	public TextView getView() {
		return (TextView) super.getView();
	}
	
	@Override
	protected void setViewValue(V value) {
		// Since set text does not clear set errors, do it manually
		getView().setError(null);
		
		if (value == null) {
			getView().setText(null);
		} else {
			getView().setText(value.toString());
		}
		
	}
	
}