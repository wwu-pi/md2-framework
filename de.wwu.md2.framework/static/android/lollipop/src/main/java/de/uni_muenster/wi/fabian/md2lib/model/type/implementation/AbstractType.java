package de.uni_muenster.wi.fabian.md2lib.model.type.implementation;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 08/07/2015.
 */
public abstract class AbstractType implements Type{

    public abstract Type clone();

    public abstract String getString();

    public abstract Boolean equals(Type value);
}
