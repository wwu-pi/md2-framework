package de.uni_muenster.wi.md2library.model.type.implementation;

import java.text.DecimalFormat;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2NumericType;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Implementation of data type float in MD2-DSL.
 * Uses float as platform representation.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2Float extends AbstractMd2NumericType {
    /**
     * Instantiates a new Md2 float.
     */
    public Md2Float() {
        super();
    }

    /**
     * Instantiates a new Md2 float.
     *
     * @param platformValue the platform value
     */
    public Md2Float(float platformValue) {
        this.platformValue = platformValue;
    }

    @Override
    public java.lang.Float getPlatformValue() {
        return (float) this.platformValue;
    }

    @Override
    public Md2Type clone() {
        return new Md2Float(this.getPlatformValue());
    }

    @Override
    public boolean gt(Md2NumericType value) {
        float floatValue;
        try {
            floatValue = tryGetFloat(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue() > floatValue);
    }

    @Override
    public boolean gte(Md2NumericType value) {
        float floatValue;
        try {
            floatValue = tryGetFloat(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue() >= floatValue);
    }

    @Override
    public boolean lt(Md2NumericType value) {
        float intValue;
        try {
            intValue = tryGetFloat(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue() < intValue);
    }

    @Override
    public boolean lte(Md2NumericType value) {
        float floatValue;
        try {
            floatValue = tryGetFloat(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue() <= floatValue);
    }

    private float tryGetFloat(Md2NumericType value) {
        if (value == null || !value.isSet())
            throw new IllegalArgumentException();
        try {
            return ((Md2Float) value).getPlatformValue();
        } catch (ClassCastException e) {
            throw new IllegalArgumentException();
        }
    }

    @Override
    public boolean equals(Md2Type value) {
        if (!super.equals(value))
            return false;

        if (!(value instanceof Md2Float))
            return false;

        Md2Float floatValue = (Md2Float) value;
        return (Math.abs(this.getPlatformValue() - floatValue.getPlatformValue()) < 0.01);
    }

    @Override
    public Md2String getString() {
        DecimalFormat df = new DecimalFormat("#.#");
        return new Md2String(df.format(this.getPlatformValue()));
    }

    @Override
    public String toString() {
        DecimalFormat df = new DecimalFormat("#.#");
        return df.format(this.getPlatformValue());
    }
}
