package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Implementation of data type boolean in MD2-DSL.
 * Uses boolean as platform representation.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2Boolean extends AbstractMd2DataType {

    /**
     * Instantiates a new Md2 boolean.
     *
     * @param value the value
     */
    Md2Boolean(boolean value) {
        super(value);
    }

    @Override
    public java.lang.Boolean getPlatformValue() {
        return (boolean) this.platformValue;
    }

    @Override
    public Md2Type clone() {
        return new Md2Boolean(this.getPlatformValue());
    }

    @Override
    public boolean equals(Md2Type value) {
        if (!super.equals(value))
            return false;

        if (!(value instanceof Md2Boolean))
            return false;

        Md2Boolean boolValue = (Md2Boolean) value;

        return this.getPlatformValue() == boolValue.getPlatformValue();
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
