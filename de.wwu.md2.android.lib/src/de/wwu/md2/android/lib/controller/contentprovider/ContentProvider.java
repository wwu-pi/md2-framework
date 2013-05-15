package de.wwu.md2.android.lib.controller.contentprovider;

import java.text.SimpleDateFormat;

import org.codehaus.jackson.map.DeserializationConfig;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.codehaus.jackson.type.JavaType;
import org.codehaus.jackson.type.TypeReference;

import android.database.SQLException;
import android.util.Log;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.model.Entity;

/**
 * Handles the local or remote storage and retrieval of model data.
 * 
 * A concrete CP must implement the load and save methods and may implement the
 * callbacks open and save.
 * 
 * @param <T>
 *            The entity type (collection or single) this content provider
 *            handles.
 */
public abstract class ContentProvider<T extends Entity> {
	
	protected final ObjectMapper om = new ObjectMapper();
	protected final MD2Application app;
	protected final boolean isMany;
	protected final JavaType jsonType;
	protected final Class<T> entityType;
	protected Object entity;
	
	public ContentProvider(MD2Application app, TypeReference<?> typeRef, Class<T> entityType, boolean isMany) {
		this.app = app;
		this.isMany = isMany;
		this.entityType = entityType;
		this.jsonType = om.getTypeFactory().constructType(typeRef);	
		// Configure mapper
		om.configure(SerializationConfig.Feature.WRAP_ROOT_VALUE, true);
		om.configure(DeserializationConfig.Feature.UNWRAP_ROOT_VALUE, true);
		om.setDateFormat(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ"));
	}
	
	/**
	 * Needs to be initiated when activity goes to foreground
	 */
	public void open() throws SQLException {
	}
	
	/**
	 * Needs to be initiated when activity goes to background
	 */
	public void close() {
	}
	
	public abstract void loadEntity();
	
	public abstract void saveEntity();
	
	public abstract void deleteEntity();
	
	public void throwRefreshEvent() {
		app.getEventBus().eventOccured(getClass().getSimpleName()+"_Reloaded");
	}

	@SuppressWarnings("unchecked")
	public T getEntity() {
		if (entity == null)
			resetEntity();
		return (T) entity;
	}

	protected void resetEntity(boolean silent) {
		try {
			entity = entityType.newInstance();
		} catch (Exception e) {
			Log.e(getClass().getSimpleName(), "Internal error: Could not instanciate model", e);
		}
		if (!silent) throwRefreshEvent();
	}
	
	public void resetEntity() {
		resetEntity(false);
	}
}