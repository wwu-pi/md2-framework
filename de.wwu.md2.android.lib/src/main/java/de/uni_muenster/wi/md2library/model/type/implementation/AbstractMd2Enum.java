package de.uni_muenster.wi.md2library.model.type.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Enum;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Created by Fabian on 09/07/2015.
 */

/**
 * Abstract class that represents enums in MD2-DSL.
 * Each generated enumeration should extend this class.
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2Enum extends AbstractMd2Type implements Md2Enum {

    /**
     * The Enum name.
     */
    protected String enumName;
    /**
     * The Values.
     */
    ArrayList<Md2String> values;

    /**
     * Instantiates a new Abstract md 2 enum.
     *
     * @param enumName the enum name
     */
    public AbstractMd2Enum(String enumName) {
        this.enumName = enumName;
        this.values = new ArrayList<>();
    }

    /**
     * Instantiates a new Abstract md 2 enum.
     *
     * @param enumName the enum name
     * @param values   the values
     */
    public AbstractMd2Enum(String enumName, ArrayList<Md2String> values) {
        this.enumName = enumName;
        this.values = new ArrayList<>(values);
    }

    @Override
    public Md2String getString() {

        return new Md2String(this.toString());
    }

    @Override
    public boolean equals(Md2Type value) {
        return false;
    }

    @Override
    public Md2String get(int value) {
        return this.values.get(value);
    }

    @Override
    public ArrayList<Md2String> getAll() {
        return this.values;
    }

    @Override
    public void add(Md2String value) {
        this.values.add(value);
    }

    @Override
    public void remove(Md2String value) {
        this.values.remove(value);
    }

    @Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        result.append(this.enumName + ": ");
        for (int i = 0; i < this.values.size(); i++) {
            result.append(this.values.get(i).toString());
            if (i < this.values.size() - 1) {
                result.append(", ");
            } else {
                result.append(";");
            }
        }
        return result.toString();
    }
}