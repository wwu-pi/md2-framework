package de.uni_muenster.wi.md2library.model.type.implementation;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2NumericType;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Implementation of data type dateTime in MD2-DSL.
 * Uses calendar as platform representation.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2DateTime extends AbstractMd2NumericType {
    /**
     * Instantiates a new Md2 date time.
     */
    public Md2DateTime() {
        super();
    }

    /**
     * Instantiates a new Md2 date time.
     *
     * @param platformValue the platform value
     */
    public Md2DateTime(Calendar platformValue) {
        super(platformValue);
    }

    /**
     * Instantiates a new Md2 date time.
     *
     * @param platformValue the platform value
     */
    public Md2DateTime(Md2String platformValue) {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddTHH:mm:ss");
        try {
            calendar.setTime(sdf.parse(platformValue.getPlatformValue()));
        } catch (ParseException e) {
            this.platformValue = null;
            this.isSet = false;
        }

        this.platformValue = calendar;
        this.isSet = true;
    }

    @Override
    public Calendar getPlatformValue() {
        return (Calendar) platformValue;
    }

    @Override
    public Md2Type clone() {
        return new Md2Date(this.getPlatformValue());
    }

    @Override
    public boolean gt(Md2NumericType value) {
        Calendar calendarValue;
        try {
            calendarValue = tryGetDateTime(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue().after(calendarValue));
    }

    @Override
    public boolean gte(Md2NumericType value) {
        Calendar calendarValue;
        try {
            calendarValue = tryGetDateTime(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue().after(calendarValue) || this.getPlatformValue().equals(calendarValue));
    }

    @Override
    public boolean lt(Md2NumericType value) {
        Calendar calendarValue;
        try {
            calendarValue = tryGetDateTime(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue().before(calendarValue));
    }

    @Override
    public boolean lte(Md2NumericType value) {
        Calendar calendarValue;
        try {
            calendarValue = tryGetDateTime(value);
        } catch (IllegalArgumentException e) {
            return false;
        }

        return (this.getPlatformValue().before(calendarValue) || this.getPlatformValue().equals(calendarValue));
    }

    private Calendar tryGetDateTime(Md2NumericType value) {
        if (value == null || !value.isSet())
            throw new IllegalArgumentException();
        try {
            return ((Md2DateTime) value).getPlatformValue();
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

        if (!(value instanceof Md2DateTime))
            return false;

        Md2DateTime dateTimeValue = (Md2DateTime) value;

        return this.getPlatformValue().equals(dateTimeValue.getPlatformValue());
    }

    @Override
    public Md2String getString() {
        return new Md2String(toString());
    }

    @Override
    public String toString() {
        Calendar calendar = this.getPlatformValue();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddTHH:mm:ss");
        return sdf.format(calendar);
    }
}
