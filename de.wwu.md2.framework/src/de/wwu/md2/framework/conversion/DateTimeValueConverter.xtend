package de.wwu.md2.framework.conversion;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractNullSafeConverter;
import org.eclipse.xtext.nodemodel.INode;

import com.google.common.collect.Sets;

import de.wwu.md2.framework.util.MD2Util;

/**
 * String - Time converter for strings conforming the following format:
 * {@code yyyy-MM-dd'T'hh:mm:ss[Z]} The optional 'Z' represents a RFC 822 4-digit time zone.
 * 'T' is a delimiter between the date and the time.
 */
class DateTimeValueConverter extends AbstractNullSafeConverter<Date> {
	
	final Collection<String> PATTERNS = Sets.newHashSet("yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ssXXX", "yyyy-MM-dd'T'HH:mm:ss");
	final String DEFAULT_PATTERN = "yyyy-MM-dd'T'HH:mm:ssXXX";
	
	override protected internalToString(Date date) {
		val dateFormat = new SimpleDateFormat(DEFAULT_PATTERN);
		return dateFormat.format(date);
	}
	
	override protected internalToValue(String dateStringIn, INode node) throws ValueConverterException {
		var dateString = dateStringIn
		
		// get rid of quotes
		if(dateString.indexOf("\"") != -1 || dateString.indexOf("'") != -1) {
			dateString = dateString.substring(1, dateString.length() - 1);
		}
		
		val dateFormat = new SimpleDateFormat();
		dateFormat.setLenient(false);
		
		for(String pattern : PATTERNS) {
			dateFormat.applyPattern(pattern);
			val date = MD2Util.tryToParse(dateString, dateFormat);
			if(date !== null) return date;
		}
		
		throw new ValueConverterException("No valid date format: Expects \"yyyy-MM-dd'T'HH:mm:ss[(+|-)HH:mm]\".", node, null);
	}
}
