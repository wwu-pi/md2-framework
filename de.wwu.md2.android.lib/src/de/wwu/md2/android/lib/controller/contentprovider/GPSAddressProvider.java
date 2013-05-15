package de.wwu.md2.android.lib.controller.contentprovider;

import java.util.List;
import java.util.Locale;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import de.wwu.md2.android.lib.MD2Application;
import de.wwu.md2.android.lib.view.MessageBoxFragment;

public class GPSAddressProvider {
	
	private MD2Application app;
	private GPSAddressReceiver receiver;
	
	public GPSAddressProvider(MD2Application app, GPSAddressReceiver receiver) {
		this.app = app;
		this.receiver = receiver;
	}
	
	public void provideGPSAddress() {
		// Acquire a reference to the system Location Manager
		final LocationManager locationManager = (LocationManager) app.getActiveActivity().getSystemService(
				Context.LOCATION_SERVICE);
		
		// Define a listener that responds to the location update
		LocationListener locationListener = new LocationListener() {
			@Override
			public void onLocationChanged(Location location) {
				try {
					Geocoder gc = new Geocoder(app.getActiveActivity(), Locale.getDefault());
					List<Address> addresses = gc.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
					if (addresses.size() > 0) {
						receiver.receiveGPSAddress(app, addresses.get(0), location);
						
					} else {
						showGPSPositionReceivingErrorMessage();
					}
				} catch (Exception e) {
					showGPSPositionReceivingErrorMessage();
				}
			}
			
			private void showGPSPositionReceivingErrorMessage() {
				new MessageBoxFragment("GPS position could not be received. Please try again later.").show(app
						.getActiveActivity().getFragmentManager(), "GPSPositionReceivingErrorMessage");
			}
			
			@Override
			public void onStatusChanged(String provider, int status, Bundle extras) {
			}
			
			@Override
			public void onProviderEnabled(String provider) {
			}
			
			@Override
			public void onProviderDisabled(String provider) {
			}
		};
		
		// Register the listener with the Location Manager to receive one
		// location update
		locationManager.requestSingleUpdate(LocationManager.GPS_PROVIDER, locationListener, null);
	}
	
	public interface GPSAddressReceiver {
		
		public void receiveGPSAddress(MD2Application app, Address address, Location location);
		
	}
}
