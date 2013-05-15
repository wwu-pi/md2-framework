package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.JsonSerializer;
import org.codehaus.jackson.map.SerializerProvider;

public class InternalIdSerializer extends JsonSerializer<Integer> {
	
	@Override
	public void serialize(Integer arg0, JsonGenerator arg1, SerializerProvider arg2) throws IOException,
			JsonProcessingException {
		int val = arg0.intValue();
		if (val >= 0) {
			arg1.writeNumber(val);
		} else {
			arg1.writeObject(null);
		}
		
	}
	
}
