package de.uni_muenster.wi.md2library.model.type.interfaces;

import de.uni_muenster.wi.md2library.model.type.implementation.Md2String;

/**
 * Representation of all types in MD2-DSL
 * <p/>
 * Created on 07/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Type {

    Md2Type clone();

    /**
     * Gets string.
     * Eqivalent to toString method, but returns Md2String
     *
     * @return the string
     */
    Md2String getString();

    /**
     * Equals.
     *
     * @param value the value
     * @return the boolean
     */
    boolean equals(Md2Type value);
}
