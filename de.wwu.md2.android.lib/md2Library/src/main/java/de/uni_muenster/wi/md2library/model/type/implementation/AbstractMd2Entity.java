package de.uni_muenster.wi.md2library.model.type.implementation;

import java.util.HashMap;
import java.util.Map;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Abstract class that represents entities in MD2-DSL.
 * Each generated entity should extend this class.
 * <p/>
 * TODO: Attributes are stored in map to simplify the generation of concrete entities. However, might still make sense to use fields in concrete entities instead.
 * <p/>
 * Created on 08/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2Entity extends AbstractMd2Type implements Md2Entity {
    /**
     * The Attributes.
     */
    protected HashMap<String, Md2Type> attributes;
    /**
     * The Type name.
     */
    protected String typeName;
    /**
     * The Id.
     */
    protected long _id;

    /**
     * Instantiates a new Abstract md 2 entity.
     *
     * @param typeName the type name
     */
    public AbstractMd2Entity(String typeName) {
        this.typeName = typeName;
        attributes = new HashMap();
        _id = -1;
    }

    /**
     * Instantiates a new Abstract md 2 entity.
     *
     * @param typeName   the type name
     * @param attributes the attributes
     */
    public AbstractMd2Entity(String typeName, HashMap<String, Md2Type> attributes) {
        this.typeName = typeName;
        this.attributes = new HashMap(attributes);
        this._id = -1;
    }

    @Override
    public long getId() {
        return this._id;
    }

    @Override
    public void setId(long id) {
        this._id = id;
    }

    @Override
    public Md2Type get(String attribute) {
        return attributes.get(attribute);
    }

    @Override
    public void set(String attribute, Md2Type value) {
        attributes.put(attribute, value);
    }

    @Override
    public String getTypeName() {
        return this.typeName;
    }

    @Override
    public HashMap<String, Md2Type> getAttributes() {
        return this.attributes;
    }

    @Override
    public Md2String getString() {
        return new Md2String(this.toString());
    }

    @Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        result.append(this.getTypeName() + ": (");
        for (Map.Entry<String, Md2Type> entry : this.attributes.entrySet()) {
            String key = entry.getKey();
            Md2Type val = entry.getValue();
            if (val != null) {
                result.append(key + ": " + val.getString() + "; ");
            } else {
                result.append(key + ": null; ");
            }
        }
        return result.append(")").toString();
    }

    @Override
    public boolean equals(Md2Type value) {
        if (value == null)
            return false;

        if (!(value instanceof Md2Entity))
            return false;

        Md2Entity md2EntityValue = (Md2Entity) value;

        for (Map.Entry<String, Md2Type> entry : this.attributes.entrySet()) {
            String key = entry.getKey();
            Md2Type val = entry.getValue();

            if (!val.equals(md2EntityValue.get(key)))
                return false;
        }

        return true;
    }
}
