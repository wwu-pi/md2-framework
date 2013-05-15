package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.HttpHostConnectException;

import android.os.AsyncTask;
import android.util.Log;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.view.MessageBoxFragment;

public abstract class NetworkOperation<H extends HttpUriRequest, Result> extends AsyncTask<H, Void, Result> {
	protected Exception responseError;
	protected final static Exception internalError = new Exception("An internal error occured while contacting the server.");
	
	private final HttpClient client;
	private final MD2Application app;
	
	public NetworkOperation(HttpClient client, MD2Application app) {
		this.client = client;
		this.app = app;
	}
	
	@Override
	protected Result doInBackground(H... arg0) {
		return handleRequest(arg0[0]);
	}
	
	protected void onPostExecute(Result result) {
		if (responseError != null) {
			handleNetworkError(responseError);
		} else {
			onResponse(result);
		}
	}
	
	protected HttpResponse executeRequest(H request, int expectedResult) {
		HttpResponse response = null;
		try {
			response = client.execute(request);
			if (response.getStatusLine().getStatusCode() != expectedResult) {
				Log.w(getClass().getSimpleName(), "Request returned: " + response.getStatusLine().toString());
				throw new HttpResponseException(response.getStatusLine().getStatusCode(), "");
			}
			return response;
		} catch (HttpHostConnectException e) {
			// Handle connection errors
			responseError = e;
			Log.e(this.getClass().getSimpleName(), "Cannot acces the server", e);
		} catch (HttpResponseException e) {
			// Handle status codes
			responseError = e;
			Log.e(this.getClass().getSimpleName(), "Error loading entity", e);
		} catch (IOException e) {
			responseError = internalError;
		}
		return null;
	}
	
	protected void handleNetworkError(Exception e) {
		String message = e.getLocalizedMessage();
		if (e instanceof HttpResponseException) {
			int statusCode = ((HttpResponseException) e).getStatusCode();
			if (statusCode >= 500 && statusCode < 660) {
				message = "The server experienced an error while processing the request (#"+statusCode+")";
			} else if (statusCode == 404) {
				message = "The requested entity could not be found on the server (#404)";
			} else {
				message = "A network error occured (#"+statusCode+")";
			}
		}
		new MessageBoxFragment(message).show(app.getActiveActivity().getFragmentManager(), "Network Error");
	}
	
	protected abstract Result handleRequest(H request);
	
	protected void onResponse(Result result) {
		
	}
}
