package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.JsonSerializer;
import org.codehaus.jackson.map.SerializerProvider;

import de.wwu.md2.android.lib.model.MD2Enum;

public class MD2EnumSerializer extends JsonSerializer<MD2Enum> {
	
	@Override
	public void serialize(MD2Enum arg0, JsonGenerator arg1, SerializerProvider arg2) throws IOException,
			JsonProcessingException {
		arg1.writeNumber(arg0.getSelectedIdx());
		
	}
	
}
