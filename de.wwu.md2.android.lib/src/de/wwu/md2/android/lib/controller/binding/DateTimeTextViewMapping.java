package de.wwu.md2.android.lib.controller.binding;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.text.InputType;
import android.widget.TextView;

import de.wwu.md2.android.lib.controller.contentprovider.ContentProvider;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.model.Entity;
import de.wwu.md2.android.lib.view.DatePickerFragment;
import de.wwu.md2.android.lib.view.DateTimePickerFragment;
import de.wwu.md2.android.lib.view.TimePickerFragment;

public class DateTimeTextViewMapping<E extends Entity> extends AbstractTextViewMapping<E, Date> {
	
	public DateTimeTextViewMapping(TextView associatedElement, ContentProvider<E> modelContentProvider,
			PathResolver<E, Date> resolver, MD2EventBus eventBus, String viewName, String activityName) {
		super(associatedElement, modelContentProvider, resolver, eventBus, viewName, activityName);
	}
	
	@Override
	protected Date getViewValue() {
		TextView view = getView();
		String viewValue = view.getText().toString();
		if (viewValue != null && viewValue.length() != 0) {
			int inputType = view.getInputType();
			SimpleDateFormat sdf;
			try {
				switch (inputType) {
				// Date
				case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_DATE:
					sdf = new SimpleDateFormat(DatePickerFragment.DATE_FORMAT);
					break;
				// Time
				case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_TIME:
					sdf = new SimpleDateFormat(TimePickerFragment.TIME_FORMAT);
					break;
				// DateTime
				case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_NORMAL:
					sdf = new SimpleDateFormat(DateTimePickerFragment.DATE_TIME_FORMAT);
					break;
				default:
					sdf = new SimpleDateFormat();
					break;
				}
				return sdf.parse(viewValue);
			} catch (ParseException e) {
				e.printStackTrace();
				return null;
			}
		} else {
			return null;
		}
	}
	
	@Override
	protected void setViewValue(Date value) {
		TextView view = getView();
		
		// Since set text does not clear set errors, do it manually
		view.setError(null);
		
		if (value == null) {
			view.setText(null);
		} else {
			int inputType = view.getInputType();
			SimpleDateFormat sdf;
			switch (inputType) {
			// Date
			case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_DATE:
				sdf = new SimpleDateFormat(DatePickerFragment.DATE_FORMAT);
				break;
			// Time
			case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_TIME:
				sdf = new SimpleDateFormat(TimePickerFragment.TIME_FORMAT);
				break;
			// DateTime
			case InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_NORMAL:
				sdf = new SimpleDateFormat(DateTimePickerFragment.DATE_TIME_FORMAT);
				break;
			default:
				sdf = new SimpleDateFormat();
				break;
			}
			view.setText(sdf.format(value));
		}
	}
	
}
