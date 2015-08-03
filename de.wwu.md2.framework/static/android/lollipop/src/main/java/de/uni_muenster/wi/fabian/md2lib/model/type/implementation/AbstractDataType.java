package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import java.lang.*;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.DataType;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 08/07/2015.
 */
public abstract class AbstractDataType extends AbstractType implements DataType {

    protected Object platformValue;
    protected boolean isSet;

    public AbstractDataType(){
        this.platformValue = null;
        this.isSet = false;
    }

    public AbstractDataType(Object platformValue){
        if(platformValue != null){
            this.platformValue = platformValue;
            this.isSet = true;
        }else{
            this.platformValue = null;
            this.isSet = false;
        }
    }

    @Override
    public Object getPlatformValue() {
        return platformValue;
    }

    @Override
    public boolean isSet() {
        return isSet;
    }

    @Override
    public Boolean equals(Type value) {
        if(value == null)
            return new Boolean(false);
        else
        return new Boolean(true);
    }

    public String getString(){
        return new String(this.getPlatformValue().toString());
    }

    public java.lang.String toString(){
        return this.getPlatformValue().toString();
    }
}
