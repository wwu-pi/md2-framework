package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 09/07/2015.
 */
public class Boolean extends AbstractDataType {

    Boolean(boolean value){
        super(value);
    }

    @Override
    public java.lang.Boolean getPlatformValue() {
        return (boolean) this.platformValue;
    }

    @Override
    public Type clone() {
        return new Boolean(this.getPlatformValue());
    }

    @Override
    public Boolean equals(Type value) {
        if(!super.equals(value).getPlatformValue())
            return new Boolean(false);

        if(!(value instanceof Boolean))
            return new Boolean(false);

        Boolean boolValue = (Boolean) value;

        if(this.getPlatformValue() == boolValue.getPlatformValue()){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public String getString() {
        return super.getString();
    }

    @Override
    public java.lang.String toString() {
        return super.toString();
    }
}
