package de.wwu.md2.android.lib.view;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.DatePicker;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TimePicker;

public class DateTimePickerFragment extends DialogFragment implements OnClickListener {
	
	private TextView textView;
	private DatePicker datePicker;
	private TimePicker timePicker;
	
	public final static String DATE_TIME_FORMAT = "HH:mm yyyy/MM/dd";
	
	public DateTimePickerFragment(TextView textView) {
		this.textView = textView;
	}
	
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		int year;
		int month;
		int day;
		int hour;
		int minute;
		
		if (textView.getText().length() == 0) {
			// Use the current time as the default values for the picker
			final Calendar c = Calendar.getInstance();
			year = c.get(Calendar.YEAR);
			month = c.get(Calendar.MONTH);
			day = c.get(Calendar.DAY_OF_MONTH);
			hour = c.get(Calendar.HOUR_OF_DAY);
			minute = c.get(Calendar.MINUTE);
		} else {
			try {
				SimpleDateFormat sdf = new SimpleDateFormat(DATE_TIME_FORMAT);
				Date date = sdf.parse(textView.getText().toString());
				year = date.getYear() + 1900;
				month = date.getMonth();
				day = date.getDate();
				hour = date.getHours();
				minute = date.getMinutes();
			} catch (ParseException e) {
				// Notify user about parse exception
				DialogFragment newFragment = new MessageBoxFragment(
						"The entered date and time cannot be parsed.\nThe current date and time will be used as default.");
				newFragment.show(getFragmentManager(), "wrongDateFormat");
				
				// Use the current time as the default values for the picker
				final Calendar c = Calendar.getInstance();
				year = c.get(Calendar.YEAR);
				month = c.get(Calendar.MONTH);
				day = c.get(Calendar.DAY_OF_MONTH);
				hour = c.get(Calendar.HOUR_OF_DAY);
				minute = c.get(Calendar.MINUTE);
			}
		}
		
		// Initialize view elements
		// Date Picker
		datePicker = new DatePicker(getActivity());
		datePicker.updateDate(year, month, day);
		
		// Time picker
		timePicker = new TimePicker(getActivity());
		timePicker.setCurrentHour(hour);
		timePicker.setCurrentMinute(minute);
		
		// Layout
		LinearLayout layout = new LinearLayout(getActivity());
		layout.setOrientation(LinearLayout.HORIZONTAL);
		layout.addView(timePicker);
		layout.addView(datePicker);
		layout.setGravity(Gravity.CENTER);
		
		// Alert dialog builder
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());
		alertDialogBuilder.setTitle("Set date and time");
		alertDialogBuilder.setView(layout);
		alertDialogBuilder.setPositiveButton("Set", this);
		alertDialogBuilder.setNegativeButton("Cancel", null);
		
		// Return the created alert dialog
		return alertDialogBuilder.create();
	}
	
	@Override
	public void onClick(DialogInterface dialog, int which) {
		// Since set text does not clear set errors, do it manually
		textView.setError(null);
		
		// Initialize date format
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_TIME_FORMAT);
		
		// Build date
		Date date = new Date(datePicker.getYear() - 1900, datePicker.getMonth(), datePicker.getDayOfMonth(),
				timePicker.getCurrentHour(), timePicker.getCurrentMinute());
		
		// Set text box
		textView.setText(sdf.format(date));
	}
}