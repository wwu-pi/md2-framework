package de.uni_muenster.wi.fabian.md2lib.model.type.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 07/07/2015.
 */
public interface Type {

    Type clone();

    String getString();

    Boolean equals(Type value);
}
