package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import android.util.Log;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 09/07/2015.
 */
public class String extends AbstractDataType {

    public String(){
        super();
    }

    public String(java.lang.String value){
        super(value);
    }

    @Override
    public java.lang.String getPlatformValue(){
        return (java.lang.String) super.getPlatformValue();
    }

    @Override
    public Type clone() {
        return new String(this.getPlatformValue());
    }

    @Override
    public Boolean equals(Type value) {
        if(!super.equals(value).getPlatformValue())
            return new Boolean(false);

        if(!(value instanceof String))
            return new Boolean(false);

        String stringValue = (String) value;

        if(this.getPlatformValue() == stringValue.getPlatformValue()){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public String getString(){
        return super.getString();
    }

    @Override
    public java.lang.String toString(){
        return super.toString();
    }
}
