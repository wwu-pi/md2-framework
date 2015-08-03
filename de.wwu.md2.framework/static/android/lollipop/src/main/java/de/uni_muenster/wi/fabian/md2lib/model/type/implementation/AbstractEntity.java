package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import java.util.HashMap;
import java.util.Map;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Entity;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 08/07/2015.
 */
public abstract class AbstractEntity extends AbstractType implements Entity {
    protected HashMap<String, Type> attributes;

    public AbstractEntity(){
        attributes = new HashMap();
    }

    public AbstractEntity(HashMap<String, Type> attributes){
        attributes = new HashMap(attributes);
    }

    @Override
    public Type get(String attribute) {
        return attributes.get(attribute);
    }

    @Override
    public void set(String attribute, Type value) {
        attributes.put(attribute, value);
    }

    @Override
    public String getString() {
        return new String(this.toString());
    }

    @Override
    public java.lang.String toString() {
        java.lang.String result = "(";
        for(Map.Entry<String, Type> entry : this.attributes.entrySet()) {
            String key = entry.getKey();
            Type val = entry.getValue();
            result += key + ": " + val.getString() + "; ";
        }
        return result.substring(0, result.length()-2) + ")";
    }

    @Override
    public Boolean equals(Type value) {
        if(value == null)
            return new Boolean(false);

        if(!(value instanceof Entity))
            return new Boolean(false);

        Entity entityValue = (Entity) value;

        for(Map.Entry<String, Type> entry : this.attributes.entrySet()) {
            String key = entry.getKey();
            Type val = entry.getValue();

            if(!val.equals(entityValue.get(key)).getPlatformValue())
                return new Boolean(false);
        }

        return new Boolean(true);
    }


}
