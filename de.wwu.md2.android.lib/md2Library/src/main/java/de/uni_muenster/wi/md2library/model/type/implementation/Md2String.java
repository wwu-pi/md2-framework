package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Implementation of data type string in MD2-DSL.
 * Uses string as platform representation.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2String extends AbstractMd2DataType {

    /**
     * Instantiates a new Md2 string.
     */
    public Md2String() {
        super();
    }

    /**
     * Instantiates a new Md2 string.
     *
     * @param value the value
     */
    public Md2String(java.lang.String value) {
        super(value);
    }

    @Override
    public java.lang.String getPlatformValue() {
        return (java.lang.String) super.getPlatformValue();
    }

    @Override
    public Md2Type clone() {
        return new Md2String(this.getPlatformValue());
    }

    @Override
    public boolean equals(Md2Type value) {
        if (!super.equals(value))
            return false;

        if (!(value instanceof Md2String)) {
            return false;
        }

        Md2String Md2StringValue = (Md2String) value;

        return this.getPlatformValue().equals(Md2StringValue.getPlatformValue());
    }

    @Override
    public Md2String getString() {
        return new Md2String(this.toString());
    }

    @Override
    public java.lang.String toString() {
        return super.toString();
    }
}
