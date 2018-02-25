package de.wwu.md2.framework.conversion;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractNullSafeConverter;
import org.eclipse.xtext.nodemodel.INode;

/**
 * String - Date converter for strings conforming the following format:
 * {@code yyyy-MM-dd}
 */
class DateValueConverter extends AbstractNullSafeConverter<Date> {
	
	private final String PATTERN = "yyyy-MM-dd";
	
	override protected def internalToString(Date date) {
		val dateFormat = new SimpleDateFormat(PATTERN);
		dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		return dateFormat.format(date);
	}
	
	override protected def internalToValue(String dateStringIn, INode node) throws ValueConverterException {
		var dateString = dateStringIn
		
		// get rid of quotes
		if(dateString.indexOf("\"") != -1 || dateString.indexOf("'") != -1) {
			dateString = dateString.substring(1, dateString.length() - 1);
		}
		
		try {
			val dateFormat = new SimpleDateFormat(PATTERN);
			dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
			dateFormat.setLenient(false);
			return dateFormat.parse(dateString);
		} catch (ParseException e) {
			throw new ValueConverterException("No valid date format: Expects \"" + PATTERN + "\".", node, null);
		}
	}
	
}
