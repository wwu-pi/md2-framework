package de.wwu.md2.framework.conversion;

import java.util.Date;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;

import com.google.inject.Inject;

class MD2ValueConverterService extends DefaultTerminalConverters {
	
	@Inject
	DateValueConverter dateValueConverter;
	
	@ValueConverter(rule = "DATE")
	def IValueConverter<Date> getDateConverter() {
		return dateValueConverter;
	}
	
	@Inject
	TimeValueConverter timeValueConverter;
	
	@ValueConverter(rule = "TIME")
	def IValueConverter<Date> getTimeConverter() {
		return timeValueConverter;
	}
	
	@Inject
	DateTimeValueConverter dateTimeValueConverter;
	
	@ValueConverter(rule = "DATE_TIME")
	def IValueConverter<Date> getDateTimeConverter() {
		return dateTimeValueConverter;
	}
	
	@Inject
	PercentValueConverter percentValueConverter;
	
	@ValueConverter(rule = "PERCENT")
	def IValueConverter<Integer> getPercentConverter() {
		return percentValueConverter;
	}
	
}
