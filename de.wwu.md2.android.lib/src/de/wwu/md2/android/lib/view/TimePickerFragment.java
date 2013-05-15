package de.wwu.md2.android.lib.view;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.app.Dialog;
import android.app.DialogFragment;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.widget.TextView;
import android.widget.TimePicker;

public class TimePickerFragment extends DialogFragment implements TimePickerDialog.OnTimeSetListener {
	
	private TextView textView;
	public final static String TIME_FORMAT = "HH:mm";
	
	public TimePickerFragment(TextView textView) {
		this.textView = textView;
	}
	
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		int hour;
		int minute;
		
		if (textView.getText().length() == 0) {
			// Use the current time as the default values for the picker
			final Calendar c = Calendar.getInstance();
			hour = c.get(Calendar.HOUR_OF_DAY);
			minute = c.get(Calendar.MINUTE);
		} else {
			try {
				SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
				Date date;
				date = sdf.parse(textView.getText().toString());
				hour = date.getHours();
				minute = date.getMinutes();
			} catch (ParseException e) {
				// Notify user about parse exception
				DialogFragment newFragment = new MessageBoxFragment(
						"The entered time cannot be parsed.\nThe current time will be used as default.");
				newFragment.show(getFragmentManager(), "wrongDateFormat");
				
				// Use the current time as the default values for the picker
				final Calendar c = Calendar.getInstance();
				hour = c.get(Calendar.HOUR_OF_DAY);
				minute = c.get(Calendar.MINUTE);
			}
		}
		
		// Create a new instance of TimePickerDialog and return it
		return new TimePickerDialog(getActivity(), this, hour, minute, DateFormat.is24HourFormat(getActivity()));
	}
	
	public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
		// Since set text does not clear set errors, do it manually
		textView.setError(null);
		
		// Set new value
		SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
		textView.setText(sdf.format(new Date(2001, 1, 1, hourOfDay, minute)));
	}
}
