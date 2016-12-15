package de.uni_muenster.wi.md2library.model.type.interfaces;

/**
 * {@inheritDoc}
 * <p/>
 * Representation of simpleDataTypes in MD2-DSL
 * <p/>
 * Created on 07/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2DataType extends Md2Type {
    /**
     * Gets platform value.
     *
     * @return the platform value
     */
    Object getPlatformValue();

    /**
     * Checks whether a value is set or not. Facilitates MD2's assumption that each data type can have a null value.
     *
     * @return the boolean
     */
    boolean isSet();
}
