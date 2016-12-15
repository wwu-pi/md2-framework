package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2DataType;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Abstract superclass class for data types.
 * <p/>
 * Created on 08/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2DataType extends AbstractMd2Type implements Md2DataType {

    /**
     * The Platform value.
     */
    protected Object platformValue;
    /**
     * The Is set.
     */
    protected boolean isSet;

    /**
     * Instantiates a new Abstract md2 data type.
     */
    public AbstractMd2DataType() {
        this.platformValue = null;
        this.isSet = false;
    }

    /**
     * Instantiates a new Abstract md 2 data type.
     *
     * @param platformValue the platform value
     */
    public AbstractMd2DataType(Object platformValue) {
        if (platformValue != null) {
            this.platformValue = platformValue;
            this.isSet = true;
        } else {
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
    public boolean equals(Md2Type value) {
        boolean result = value != null;
        return (value != null);
    }

    public Md2String getString() {
        return new Md2String(this.toString());
    }

    public java.lang.String toString() {
        return this.getPlatformValue().toString();
    }
}
