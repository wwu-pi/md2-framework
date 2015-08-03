package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import java.text.DecimalFormat;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.NumericType;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 09/07/2015.
 */
public class Float extends AbstractNumericType {
    public Float(){
        super();
    }

    public Float(float platformValue){
        this.platformValue = platformValue;
    }

    @Override
    public java.lang.Float getPlatformValue() {
        return (float) this.platformValue;
    }

    @Override
    public Type clone() {
        return new Float(this.getPlatformValue());
    }

    @Override
    public Boolean gt(NumericType value) {
        float floatValue;
        try{
            floatValue = tryGetFloat(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() > floatValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean gte(NumericType value) {
        float floatValue;
        try{
            floatValue = tryGetFloat(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() >= floatValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean lt(NumericType value) {
        float intValue;
        try{
            intValue = tryGetFloat(value);
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
        float floatValue;
        try{
            floatValue = tryGetFloat(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue() <= floatValue){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    private float tryGetFloat(NumericType value){
        if(value == null || !value.isSet())
            throw new IllegalArgumentException();
        try{
            return ((Float) value).getPlatformValue();
        }catch(ClassCastException e){
            throw new IllegalArgumentException();
        }
    }

    @Override
    public Boolean equals(Type value) {
        if(!super.equals(value).getPlatformValue())
            return new Boolean(false);

        if(!(value instanceof Float))
            return new Boolean(false);

        Float floatValue = (Float) value;
        if(Math.abs(this.getPlatformValue() - floatValue.getPlatformValue()) < 0.01) {
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public String getString() {
        DecimalFormat df = new DecimalFormat("#.#");
        return new String(df.format(this.getPlatformValue()));
    }

    @Override
    public java.lang.String toString() {
        DecimalFormat df = new DecimalFormat("#.#");
        return df.format(this.getPlatformValue());
    }
}
