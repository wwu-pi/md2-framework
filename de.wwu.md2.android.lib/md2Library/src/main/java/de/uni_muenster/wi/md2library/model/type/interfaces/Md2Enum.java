package de.uni_muenster.wi.md2library.model.type.interfaces;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.model.type.implementation.Md2String;

/**
 * {@inheritDoc}
 * <p/>
 * Representation of enumerations in MD2-DSL
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Enum extends Md2Type {
    /**
     * Get md2 string.
     *
     * @param id the id
     * @return the md 2 string
     */
    Md2String get(int id);

    /**
     * Gets all strings in enum.
     *
     * @return the all
     */
    ArrayList<Md2String> getAll();

    /**
     * Add string to enum
     *
     * @param value the value
     */
    void add(Md2String value);

    /**
     * Remove string from enum.
     *
     * @param value the value
     */
    void remove(Md2String value);
}
