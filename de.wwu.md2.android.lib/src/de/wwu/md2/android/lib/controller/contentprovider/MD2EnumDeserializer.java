package de.wwu.md2.android.lib.controller.contentprovider;

import java.io.IOException;

import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.DeserializationContext;
import org.codehaus.jackson.map.JsonDeserializer;

import de.wwu.md2.android.lib.model.MD2Enum;

public class MD2EnumDeserializer<E extends MD2Enum> extends JsonDeserializer<E> {
	
	private final Class<E> enumType;
	
	public MD2EnumDeserializer(Class<E> enumType) {
		this.enumType = enumType;
	}
	
	@Override
	public E deserialize(JsonParser jp, DeserializationContext arg1) throws IOException, JsonProcessingException {
		try {
			E newEnum = enumType.newInstance();
			newEnum.setSelectedIdx(jp.getValueAsInt(-1));
			return newEnum;
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return null;
	}
	
}