package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.NumericType;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 09/07/2015.
 */
public class Integer extends AbstractNumericType{
    public Integer(){
        super();
    }

    public Integer(int platformValue){
        super(platformValue);
    }

    @Override
    public java.lang.Integer getPlatformValue() {
        return (int) platformValue;
    }

    @Override
    public Type clone() {
        return new Integer(this.getPlatformValue());
    }

    @Override
    public Boolean gt(NumericType value) {
        int intValue;
        try{
            intValue = tryGetInt(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() > intValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean gte(NumericType value) {
        int intValue;
        try{
            intValue = tryGetInt(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() >= intValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean lt(NumericType value) {
        int intValue;
        try{
            intValue = tryGetInt(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() < intValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean lte(NumericType value) {
        int intValue;
        try{
            intValue = tryGetInt(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() <= intValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    private int tryGetInt(NumericType value){
        if(value == null || !value.isSet())
            throw new IllegalArgumentException();
        try{
            return ((Integer) value).getPlatformValue();
        }catch(ClassCastException e){
            throw new IllegalArgumentException();
        }catch(NullPointerException e){
            throw new IllegalArgumentException();
        }
    }

    @Override
    public Boolean equals(Type value) {
        if(!super.equals(value).getPlatformValue())
            return new Boolean(false);

        if(!(value instanceof Integer))
            return new Boolean(false);

        Integer integerValue = (Integer) value;

        if(this.getPlatformValue() == integerValue.getPlatformValue()){
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
