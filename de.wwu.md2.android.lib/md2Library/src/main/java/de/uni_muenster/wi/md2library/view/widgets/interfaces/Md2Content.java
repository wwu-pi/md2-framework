package de.uni_muenster.wi.md2library.view.widgets.interfaces;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * {@inheritDoc}
 * <p/>
 * Represents ContentElement in MD2-DSL
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Content extends Md2Widget {

    /**
     * Gets value.
     *
     * @return the value
     */
    Md2Type getValue();

    /**
     * Sets value.
     *
     * @param value the value
     */
    void setValue(Md2Type value);
}
