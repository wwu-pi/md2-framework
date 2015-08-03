package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.NumericType;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 09/07/2015.
 */
public class Time extends AbstractNumericType {
    public Time(){
        super();
    }

    public Time(Calendar platformValue){
        super(platformValue);
    }

    public Time(String platformValue){
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        try {
            calendar.setTime(sdf.parse(platformValue.getPlatformValue()));
        }catch(ParseException e){
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
    public Type clone() {
        return new Date(this.getPlatformValue());
    }

    @Override
    public Boolean gt(NumericType value) {
        Calendar calendarValue;
        try{
            calendarValue = tryGetDate(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue().after(calendarValue)){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean gte(NumericType value) {
        Calendar calendarValue;
        try{
            calendarValue = tryGetDate(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue().after(calendarValue) || this.getPlatformValue().equals(calendarValue)){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean lt(NumericType value) {
        Calendar calendarValue;
        try{
            calendarValue = tryGetDate(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue().before(calendarValue)){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public Boolean lte(NumericType value) {
        Calendar calendarValue;
        try{
            calendarValue = tryGetDate(value);
        }catch(IllegalArgumentException e){
            return new Boolean(false);
        }

        if(this.getPlatformValue().before(calendarValue) || this.getPlatformValue().equals(calendarValue)){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    private Calendar tryGetDate(NumericType value){
        if(value == null || !value.isSet())
            throw new IllegalArgumentException();
        try{
            return ((Time) value).getPlatformValue();
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

        if(!(value instanceof Time))
            return new Boolean(false);

        Time timeValue = (Time) value;

        if(this.getPlatformValue().equals(timeValue.platformValue)){
            return new Boolean(true);
        }else{
            return new Boolean(false);
        }
    }

    @Override
    public String getString() {
        Calendar calendar = this.getPlatformValue();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return new String(sdf.format(calendar));
    }

    @Override
    public java.lang.String toString() {
        Calendar calendar = this.getPlatformValue();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(calendar);
    }
}
