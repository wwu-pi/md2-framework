package de.uni_muenster.wi.md2library.model.contentProvider.interfaces;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Interface definition for content providers.
 * Represents the ContentProvider element in MD2-DSL
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2ContentProvider {
    /**
     * Gets key.
     *
     * @return the key
     */
    String getKey();

    /**
     * Gets content.
     *
     * @return the content
     */
    Md2Entity getContent();

    /**
     * Sets content.
     *
     * @param content the content
     */
    void setContent(Md2Entity content);

    /**
     * Register attribute on change handler.
     *
     * @param attribute                 the attribute
     * @param onAttributeChangedHandler the on attribute changed handler
     */
    void registerAttributeOnChangeHandler(String attribute, Md2OnAttributeChangedHandler onAttributeChangedHandler);

    /**
     * Unregister attribute on change handler.
     *
     * @param attribute the attribute
     */
    void unregisterAttributeOnChangeHandler(String attribute);

    /**
     * Gets on attribute changed handler.
     *
     * @param attribute the attribute
     * @return the on attribute changed handler
     */
    Md2OnAttributeChangedHandler getOnAttributeChangedHandler(String attribute);

    /**
     * Gets value.
     *
     * @param attribute the attribute
     * @return the value
     */
    Md2Type getValue(String attribute);

    /**
     * Sets value.
     *
     * @param attribute the attribute
     * @param value     the value
     */
    void setValue(String attribute, Md2Type value);

    /**
     * Reset.
     */
    void reset();

    /**
     * Load.
     */
    void load();

    /**
     * Save.
     */
    void save();

    /**
     * Remove.
     */
    void remove();
}
