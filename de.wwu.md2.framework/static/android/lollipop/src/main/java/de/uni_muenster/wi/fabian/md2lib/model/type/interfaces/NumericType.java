package de.uni_muenster.wi.fabian.md2lib.model.type.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;

/**
 * Created by Fabian on 07/07/2015.
 */
public interface NumericType extends DataType {
    Boolean gt(NumericType value);
    Boolean gte(NumericType value);
    Boolean lt(NumericType value);
    Boolean lte(NumericType value);
}
