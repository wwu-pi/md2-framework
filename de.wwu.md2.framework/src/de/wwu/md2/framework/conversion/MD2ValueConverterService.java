package de.wwu.md2.framework.conversion;

import java.util.Date;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;

import com.google.inject.Inject;

public class MD2ValueConverterService extends DefaultTerminalConverters {
	
	@Inject
	private DateValueConverter dateValueConverter;
	
	@ValueConverter(rule = "DATE")
	public IValueConverter<Date> getDateConverter() {
		return dateValueConverter;
	}
	
	@Inject
	private TimeValueConverter timeValueConverter;
	
	@ValueConverter(rule = "TIME")
	public IValueConverter<Date> getTimeConverter() {
		return timeValueConverter;
	}
	
	@Inject
	private DateTimeValueConverter dateTimeValueConverter;
	
	@ValueConverter(rule = "DATE_TIME")
	public IValueConverter<Date> getDateTimeConverter() {
		return dateTimeValueConverter;
	}
	
	@Inject
	private PercentValueConverter percentValueConverter;
	
	@ValueConverter(rule = "PERCENT")
	public IValueConverter<Integer> getPercentConverter() {
		return percentValueConverter;
	}
	
}
