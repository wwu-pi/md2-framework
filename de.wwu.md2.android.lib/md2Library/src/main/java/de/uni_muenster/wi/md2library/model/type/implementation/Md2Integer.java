package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2NumericType;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Implementation of data type integer in MD2-DSL.
 * Uses integer as platform representation.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2Integer extends AbstractMd2NumericType {
    /**
     * Instantiates a new Md 2 integer.
     */
    public Md2Integer() {
        super();
    }

    /**
     * Instantiates a new Md 2 integer.
     *
     * @param platformValue the platform value
     */
    public Md2Integer(int platformValue) {
        super(platformValue);
    }

    @Override
    public java.lang.Integer getPlatformValue() {
        return (int) platformValue;
    }

    @Override
    public Md2Type clone() {
        return new Md2Integer(this.getPlatformValue());
    }

    @Override
    public boolean gt(Md2NumericType value) {
        int intValue;
        try {
            intValue = tryGetInt(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return this.getPlatformValue() > intValue;
    }

    @Override
    public boolean gte(Md2NumericType value) {
        int intValue;
        try {
            intValue = tryGetInt(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return this.getPlatformValue() >= intValue;
    }

    @Override
    public boolean lt(Md2NumericType value) {
        int intValue;
        try {
            intValue = tryGetInt(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return this.getPlatformValue() < intValue;
    }

    @Override
    public boolean lte(Md2NumericType value) {
        int intValue;
        try {
            intValue = tryGetInt(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return this.getPlatformValue() <= intValue;
    }

    private int tryGetInt(Md2NumericType value) {
        if (value == null || !value.isSet())
            throw new IllegalArgumentException();
        try {
            return ((Md2Integer) value).getPlatformValue();
        } catch (ClassCastException e) {
            throw new IllegalArgumentException();
        } catch (NullPointerException e) {
            throw new IllegalArgumentException();
        }
    }

    @Override
    public boolean equals(Md2Type value) {
        if (!super.equals(value))
            return false;

        if (!(value instanceof Md2Integer))
            return false;

        Md2Integer integerValue = (Md2Integer) value;

        return this.getPlatformValue().equals(integerValue.getPlatformValue());
    }

    @Override
    public Md2String getString() {
        return super.getString();
    }

    @Override
    public String toString() {
        return super.toString();
    }

}
