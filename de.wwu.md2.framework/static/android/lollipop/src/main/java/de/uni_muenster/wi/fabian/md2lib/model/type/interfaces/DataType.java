package de.uni_muenster.wi.fabian.md2lib.model.type.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;

/**
 * Created by Fabian on 07/07/2015.
 */
public interface DataType extends Type{
    Object getPlatformValue();
    boolean isSet();
}
