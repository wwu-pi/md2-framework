package de.uni_muenster.wi.md2library.model.type.implementation;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;


/**
 * Abstract superclass class for all types.
 * <p/>
 * Created on 08/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2Type implements Md2Type {

    public abstract Md2Type clone();

    public abstract Md2String getString();

    public abstract boolean equals(Md2Type value);
}
