package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.JsonSerializer;
import org.codehaus.jackson.map.SerializerProvider;

public class MD2DateSerializer extends JsonSerializer<Date> {
	
	private final static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
	@Override
	public void serialize(Date arg0, JsonGenerator arg1, SerializerProvider arg2) throws IOException,
			JsonProcessingException {
		String result = dateFormat.format(arg0);
		result = result.substring(0, result.length()-2) + ':' + result.substring(result.length()-2, result.length());
		arg1.writeString(result);
	}
	
}
