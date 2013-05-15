package de.wwu.md2.android.lib.controller.binding;

import java.io.Serializable;

import android.util.Log;
import android.view.View;
import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
import de.wwu.md2.android.lib.model.Entity;

/**
 * A mapping between an entity object and a view element.
 * 
 * Acts as a bidirectional observer that handles updates between view and model. 
 * Concrete subclasses that determine the interaction with respective view classes should be implemented.
 *
 * @param <E> The class of entities being mapped
 * @param <V> The type of values being mapped
 */
public abstract class Mapping<E extends Entity, V extends Serializable> {
	
	private final View view;
	private ContentProvider<E> contentProvider;
	private final PathResolver<E, V> resolver;
	
	private final MD2EventHandler updateViewHandler = new MD2EventHandler() {
		@Override
		public void eventOccured() {
			updateView();
		}
	};

	public Mapping(View associatedElement, ContentProvider<E> modelContentProvider, PathResolver<E, V> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		if (associatedElement == null) throw new IllegalArgumentException("associatedElement can't be null");
		if (modelContentProvider == null) throw new IllegalArgumentException("modelContentProvider can't be null");
		if (resolver == null) throw new IllegalArgumentException("resolver can't be null");
		view = associatedElement;
		contentProvider = modelContentProvider;
		this.resolver = resolver;
		init();
		updateView();
		
		// Subscribe mapping at event bus to receive updates of view element and get informed on activity switches
		eventBus.subscribe(viewName + "_FocusLeft", viewName + "_FocusLeft_" + getClass().getSimpleName(), new MD2EventHandler() {
			
			@Override
			public void eventOccured() {
				updateModel();
			}
		});
		eventBus.subscribe(activityName + "_Activated", 
				activityName + "_Activated_" + viewName + "_" + getClass().getSimpleName(),
				updateViewHandler);
		eventBus.subscribe(modelContentProvider.getClass().getSimpleName() + "_Reloaded",
				modelContentProvider.getClass().getSimpleName() + "_Reloaded_" + viewName + "_" + getClass().getSimpleName(),
				updateViewHandler);
	}
	
	/**
	 * Optional callback subclasses may use to do initialization during instantiation.
	 */
	protected void init() {
		
	}
	
	/**
	 * Update the view with the entity's current value.
	 */
	protected void updateView() {
		try {
			setViewValue(getEntityValue());
		} catch (Exception e) {
			Log.d(getClass().getSimpleName(), "Error updating view", e);
		}
	}
	
	protected void updateModel() {
		V value = null;
		try {
			value = getViewValue();
		} catch (Exception e) {
			Log.d(getClass().getSimpleName(), "Error reading view value", e);
		}
		setEntityValue(value);
	}
	
	protected abstract V getViewValue();
	
	protected abstract void setViewValue(V value);

	
	protected V getEntityValue() {
		try {
			return resolver.retrieveValue(contentProvider.getEntity());
		} catch (Exception e) {
			Log.d(getClass().getSimpleName(), "Exception in path resolver", e);
		}
		return null;
	}
	
	protected void setEntityValue(V value) {
		try {
			resolver.adaptValue(contentProvider.getEntity(), value);
		} catch (Exception e) {
			Log.d(getClass().getSimpleName(), "Exception in path resolver", e);
		}
	}

	/**
	 * Mappings are equal if they're for the same view and entity
	 */
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Mapping)) return false;
		Mapping<?, ?> other = (Mapping<?, ?>)o;
		return view.equals(other.getView()) && contentProvider.equals(other.getEntity());
	}
	
	protected PathResolver<E, V> getResolver() {
		return resolver;
	}
	protected View getView() {
		return view;
	}

	protected E getEntity() {
		return contentProvider.getEntity();
	}
}
