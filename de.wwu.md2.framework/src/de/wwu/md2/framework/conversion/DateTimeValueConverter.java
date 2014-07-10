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
public class DateTimeValueConverter extends AbstractNullSafeConverter<Date> {
	
	private final Collection<String> PATTERNS = Sets.newHashSet("yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ssXXX", "yyyy-MM-dd'T'HH:mm:ss");
	private final String DEFAULT_PATTERN = "yyyy-MM-dd'T'HH:mm:ssXXX";
	
	@Override
	protected String internalToString(Date date) {
		SimpleDateFormat dateFormat = new SimpleDateFormat(DEFAULT_PATTERN);
		return dateFormat.format(date);
	}
	
	@Override
	protected Date internalToValue(String dateString, INode node) throws ValueConverterException {
		
		// get rid of quotes
		if(dateString.indexOf("\"") != -1 || dateString.indexOf("'") != -1) {
			dateString = dateString.substring(1, dateString.length() - 1);
		}
		
		SimpleDateFormat dateFormat = new SimpleDateFormat();
		dateFormat.setLenient(false);
		Date date = null;
		
		for(String pattern : PATTERNS) {
			dateFormat.applyPattern(pattern);
			date = MD2Util.tryToParse(dateString, dateFormat);
			if(date != null) break;
		}
		
		if(date == null) {
			throw new ValueConverterException("No valid date format: Expects \"yyyy-MM-dd'T'HH:mm:ss[(+|-)HH:mm]\".", node, null);
		} else {
			return date;
		}
	}
}
