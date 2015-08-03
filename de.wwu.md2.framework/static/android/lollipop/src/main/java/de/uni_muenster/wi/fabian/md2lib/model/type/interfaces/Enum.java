package de.uni_muenster.wi.fabian.md2lib.model.type.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 09/07/2015.
 */
public interface Enum extends Type{
    void get(String value);
    void add(String value);
    void remove(String value);
}
