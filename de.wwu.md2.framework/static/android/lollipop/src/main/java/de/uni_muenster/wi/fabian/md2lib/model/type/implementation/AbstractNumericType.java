package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.NumericType;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 08/07/2015.
 */
public abstract class AbstractNumericType extends AbstractDataType implements NumericType{

    public AbstractNumericType(){
        super();
    }

    public AbstractNumericType(Object platformValue){
        super(platformValue);
    }

    @Override
    public Boolean equals(Type value) {
        return super.equals(value);
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
