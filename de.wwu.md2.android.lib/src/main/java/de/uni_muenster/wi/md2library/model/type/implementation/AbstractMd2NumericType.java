package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2NumericType;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Abstract superclass class for numeric types.
 * <p/>
 * Created on 08/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2NumericType extends AbstractMd2DataType implements Md2NumericType {

    /**
     * Instantiates a new Abstract md 2 numeric type.
     */
    public AbstractMd2NumericType() {
        super();
    }

    /**
     * Instantiates a new Abstract md 2 numeric type.
     *
     * @param platformValue the platform value
     */
    public AbstractMd2NumericType(Object platformValue) {
        super(platformValue);
    }

    @Override
    public boolean equals(Md2Type value) {
        return super.equals(value);
    }

    @Override
    public Md2String getString() {
        return super.getString();
    }

    @Override
    public java.lang.String toString() {
        return super.toString();
    }
}
