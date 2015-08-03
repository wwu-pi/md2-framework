package de.uni_muenster.wi.fabian.md2lib.model.type.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 07/07/2015.
 */
public interface Entity extends Type{
    Type get(String attribute);
    void set(String attribute, Type value);
}
