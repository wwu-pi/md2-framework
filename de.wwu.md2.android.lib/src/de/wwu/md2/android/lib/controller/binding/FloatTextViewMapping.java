package de.wwu.md2.android.lib.controller.binding;

import android.text.InputType;
import android.widget.TextView;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;

public class FloatTextViewMapping<E extends Entity> extends AbstractTextViewMapping<E, Float> {
	
	public FloatTextViewMapping(TextView associatedElement, ContentProvider<E> modelContentProvider, PathResolver<E, Float> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
	}
	
	@Override
	protected void init() {
		getView().setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
	}
	
	@Override
	protected Float getViewValue() {
		String viewValue = getView().getText().toString();
		if(viewValue != null && viewValue.length() != 0) {
			return Float.parseFloat(viewValue);
		}
		else {
			return null;
		}
	}
	
}