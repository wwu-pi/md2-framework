package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.DeserializationConfig;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

import android.net.Uri;
import android.util.Log;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.StringExtensions;
import de.wwu.md2.android.lib.model.Entity;

public class RemoteContentProvider<T extends Entity> extends ContentProvider<T> {
	
	private HttpClient client = new DefaultHttpClient();
	
	private final String baseUrl;
	
	private final String resourceUrl;
	
	private ObjectMapper defaultOm;
	
	public RemoteContentProvider(MD2Application app, TypeReference<?> typeRef, Class<T> entityType, boolean isMany,
			String baseUrl) {
		super(app, typeRef, entityType, isMany);
		this.baseUrl = baseUrl;
		this.resourceUrl = buildUrl();
		defaultOm = new ObjectMapper();
		defaultOm.configure(DeserializationConfig.Feature.UNWRAP_ROOT_VALUE, false);
	}
	
	private String buildUrl() {
		String resourceName = StringExtensions.toFirstLower(entityType.getSimpleName());
		return baseUrl + (baseUrl.endsWith("/") ? "" : "/") + resourceName;
	}
	
	@Override
	public void loadEntity() {
		String url = resourceUrl + (isMany ? "" : "/first");
		String filter = getFilter();
		if (filter != null)
			url += "?filter=" + Uri.encode(filter);
		
		HttpGet request = new HttpGet(url);
		request.setHeader("Accept-Charset", "utf-8");
		
		new NetworkOperation<HttpGet, Object>(client, app) {
			
			@Override
			protected Object handleRequest(HttpGet request) {
				HttpResponse response = executeRequest(request, 200);
				try {
					if (response != null)
						return om.readValue(response.getEntity().getContent(), jsonType);
				} catch (IllegalStateException e) {
					responseError = e;
				} catch (IOException e) {
					responseError = e;
				}
				return null;
			}
			
			@Override
			protected void onResponse(Object result) {
				if (result != null) {
					entity = result;
					throwRefreshEvent();
				}
			}
		}.execute(request);
	}
	
	@Override
	public void saveEntity() {
		// Setup request
		HttpPut request = new HttpPut(resourceUrl);
		request.setHeader("Content-Type", "application/json; charset=utf-8");
		
		// Setup background thread for serialization and network request
		new NetworkOperation<HttpPut, HttpResponse>(client, app) {
			
			@Override
			protected HttpResponse handleRequest(HttpPut request) {
				// Deserialze entity
				String json = "";
				try {
					json = om.writeValueAsString(entity);
					
					// Set serialized entity as body
					try {
						// TODO Debug
						Log.d(getClass().getSimpleName(), "Request body: " + json);
						request.setEntity(new StringEntity(json, "UTF-8"));
						
						// Execute request
						return executeRequest(request, 200);
					} catch (UnsupportedEncodingException e) {
						// TODO Handle serialization errors
						Log.e(getClass().getSimpleName(), "Internal error: Encoding for JSON not found", e);
						responseError = internalError;
					}
				} catch (IOException e) {
					Log.e(getClass().getSimpleName(), "Internal error: Unable to serialize entitiy : " + entity, e);
					responseError = internalError;
				}
				return null;
			}
			
			protected void onResponse(HttpResponse result) {
				if (result != null) {
					try {
						JsonNode json = defaultOm.readTree(result.getEntity().getContent());
						setInternalIdsFromSaveResponse(json);
					} catch (IllegalStateException e) {
						Log.e(getClass().getSimpleName(), "Internal error in parsing save response", e);
					} catch (IOException e) {
						Log.e(getClass().getSimpleName(), "Internal error in parsing save response", e);
					}
				}
			};
			
		}.execute(request);
	}
	
	protected void setInternalIdsFromSaveResponse(JsonNode response) {
		try {
			int newId = response.get("internalId").get("__internalId").asInt();
			getEntity().setInternalId(newId);
		} catch (Exception e) {
			Log.e(getClass().getSimpleName(), "Malformed json response received", e);
		}
	}
	
	protected String getFilter() {
		return null;
	}
	
	@Override
	public void deleteEntity() {
		if (entity != null) {
			int internalId = getEntity().getInternalId();
			if (internalId >= 0) {
				HttpDelete request = new HttpDelete(resourceUrl + '/' + internalId);
				new NetworkOperation<HttpDelete, Void>(client, app) {
					
					@Override
					protected Void handleRequest(HttpDelete request) {
						if (executeRequest(request, 204) != null)
							resetEntity();
						return null;
					}
				}.execute(request);
			} else {
				resetEntity();
			}
		}
	}
	
}
