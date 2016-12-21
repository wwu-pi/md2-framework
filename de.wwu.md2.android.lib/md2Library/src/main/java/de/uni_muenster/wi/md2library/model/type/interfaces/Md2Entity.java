package de.uni_muenster.wi.md2library.model.type.interfaces;

import java.util.HashMap;

/**
 * {@inheritDoc}
 * <p/>
 * Representation of entities in MD2-DSL
 * <p/>
 * Created on 07/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Entity extends Md2Type {
    /**
     * Gets id.
     *
     * @return the id
     */
    long getId();

    /**
     * Sets id.
     *
     * @param id the id
     */
    void setId(long id);

    /**
     * Get a attribute by key
     *
     * @param attribute the attribute
     * @return the md 2 type
     */
    Md2Type get(String attribute);

    /**
     * Set a attribute.
     *
     * @param attribute the attribute
     * @param value     the value
     */
    void set(String attribute, Md2Type value);

    /**
     * Gets type name.
     * Should match name defined in MD2 model.
     *
     * @return the type name
     */
    String getTypeName();

    /**
     * Gets map that stores all attributes.
     *
     * @return the attributes
     */
    HashMap<String, Md2Type> getAttributes();
}
