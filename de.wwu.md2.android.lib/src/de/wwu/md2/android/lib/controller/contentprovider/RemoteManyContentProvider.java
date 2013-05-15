package de.wwu.md2.android.lib.controller.contentprovider;
import java.util.ArrayList;
import java.util.List;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.type.TypeReference;

import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.model.Entity;


public class RemoteManyContentProvider<T extends Entity> extends RemoteContentProvider<T> {

	private int selectedIdx = 0;
	
	private T entityNullObject;

	public RemoteManyContentProvider(MD2Application app, TypeReference<?> typeRef, Class<T> entityType, boolean isMany, String baseUrl) {
		super(app, typeRef, entityType, isMany, baseUrl);
		
		try {
			entityNullObject = entityType.newInstance();
		} catch (Exception e) {
			entityNullObject = null;
			e.printStackTrace();
		}
	}
	
	public void selectEntity(int idx) {
		this.selectedIdx = (idx > 0 ? idx: 0);
		throwRefreshEvent();
	}
	
	public List<T> getEntityList() {
		if (entity != null) {
			return castEntity();
		}
		return new ArrayList<T>(0);
	}
	
	@SuppressWarnings("unchecked")
	private List<T> castEntity() {
		if (entity == null) return null;
		return (List<T>) this.entity;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public T getEntity() {
		if (entity != null && selectedIdx >= 0)
			return ((List<T>) this.entity).get(selectedIdx);
		return entityNullObject;
	}
	
	@Override
	protected void resetEntity(boolean silent) {
		super.resetEntity(silent);
		selectedIdx = 0;
	}
	
	@Override
	protected void setInternalIdsFromSaveResponse(JsonNode response) {
		// TODO Implement
	}
}
