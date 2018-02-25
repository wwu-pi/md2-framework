package de.wwu.md2.framework.conversion

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
 * {@code hh:mm:ss[Z]} The optional 'Z' represents a RFC 822 4-digit time zone.
 */
class TimeValueConverter extends AbstractNullSafeConverter<Date> {
	
	private final Collection<String> PATTERNS = Sets.newHashSet("HH:mm:ssZ", "HH:mm:ssXXX", "HH:mm:ss");
	private final String DEFAULT_PATTERN = "HH:mm:ssXXX";
	
	override protected def internalToString(Date date) {
		return new SimpleDateFormat(DEFAULT_PATTERN).format(date);
	}
	
	override protected def internalToValue(String dateStringIn, INode node) throws ValueConverterException {
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
		
		throw new ValueConverterException("No valid date format: Expects \"HH:mm:ss[(+|-)HHmm]\".", node, null);
	}
	
}
