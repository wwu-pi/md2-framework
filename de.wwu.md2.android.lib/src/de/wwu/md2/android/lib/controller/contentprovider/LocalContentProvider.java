package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.FileOutputStream;

import org.codehaus.jackson.type.TypeReference;

import android.app.Activity;
import android.content.Context;
import android.database.SQLException;
import android.util.Log;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.model.Entity;

/**
 * Content Provider implementation that stores entities locally, serialized in json files.
 * 
 */
public class LocalContentProvider<T extends Entity> extends ContentProvider<T> {
	
	private final String storageFilename;

	public LocalContentProvider(MD2Application app, TypeReference<?> typeRef, Class<T> entityType, boolean isMany, String storageFilename) {
		super(app, typeRef, entityType, isMany);
		this.storageFilename = storageFilename;
	}
	
	private Activity getCtx() {
		return app.getActiveActivity();
	}
	
	@Override
	public void open() throws SQLException {
	}
	
	@Override
	public void close() {
	}
	
	@Override
	public void loadEntity() {
		entity = null;
		try {
			entity = om.readValue(getCtx().getFileStreamPath(storageFilename), jsonType);
			throwRefreshEvent();
		} catch (Exception e) {
			Log.w(getClass().getSimpleName(), "Error while loading", e);
		}
	}
	
	@Override
	public void saveEntity() {
		try {
			FileOutputStream fos = getCtx().openFileOutput(storageFilename, Context.MODE_PRIVATE);
			try {
				om.writeValue(fos, entity);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			fos.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void deleteEntity() {
		getCtx().deleteFile(storageFilename);
	}
}