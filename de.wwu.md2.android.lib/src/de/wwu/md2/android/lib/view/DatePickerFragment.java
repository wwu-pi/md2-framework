package de.wwu.md2.android.lib.view;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.os.Bundle;
import android.widget.DatePicker;
import android.widget.TextView;

public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {
	
	private TextView textView;
	
	public final static String DATE_FORMAT = "yyyy/MM/dd";
	
	public DatePickerFragment(TextView textView) {
		this.textView = textView;
	}
	
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		int year;
		int month;
		int day;
		
		if (textView.getText().length() == 0) {
			// Use the current date as the default date in the picker
			final Calendar c = Calendar.getInstance();
			year = c.get(Calendar.YEAR);
			month = c.get(Calendar.MONTH);
			day = c.get(Calendar.DAY_OF_MONTH);
		} else {
			try {
				SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
				Date date = sdf.parse(textView.getText().toString());
				year = date.getYear() + 1900;
				month = date.getMonth();
				day = date.getDate();
			} catch (ParseException e) {
				// Notify user about parse exception
				DialogFragment newFragment = new MessageBoxFragment(
						"The entered date cannot be parsed.\nThe current date will be used as default.");
				newFragment.show(getFragmentManager(), "wrongDateFormat");
				
				// Use the current time as the default values for the picker
				final Calendar c = Calendar.getInstance();
				year = c.get(Calendar.YEAR);
				month = c.get(Calendar.MONTH);
				day = c.get(Calendar.DAY_OF_MONTH);
			}
		}
		
		// Create a new instance of DatePickerDialog and return it
		return new DatePickerDialog(getActivity(), this, year, month, day);
	}
	
	public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
		// Since set text does not clear set errors, do it manually
		textView.setError(null);
		
		// Set new value
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
		textView.setText(sdf.format(new Date(year - 1900, monthOfYear, dayOfMonth)));
	}
}