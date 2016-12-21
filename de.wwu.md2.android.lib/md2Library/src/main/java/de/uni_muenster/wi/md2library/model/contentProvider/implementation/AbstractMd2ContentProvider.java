package de.uni_muenster.wi.md2library.model.contentProvider.implementation;

import java.util.HashMap;
import java.util.Set;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2DataStore;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Entity;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;

/**
 * Abstract super class for content providers.
 * Concrete sub-classes are generated.
 * Represents the ContentProvider element in MD2-DSL
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2ContentProvider implements Md2ContentProvider {

    /**
     * The Key.
     */
    protected String key;
    /**
     * The Content.
     */
    protected Md2Entity content;
    /**
     * The Backup.
     */
    protected Md2Entity backup;
    /**
     * The Md 2 data store.
     */
    protected Md2DataStore md2DataStore;
    /**
     * The Attribute changed event handlers.
     */
//protected HashMap<String, Md2Type> observedAttributes;
    protected HashMap<String, Md2OnAttributeChangedHandler> attributeChangedEventHandlers;
    /**
     * The Internal id.
     */
    protected long internalId;
    /**
     * The Exists in data store.
     */
    protected boolean existsInDataStore;

    /**
     * Instantiates a new Abstract md 2 content provider.
     *
     * @param key          the key
     * @param content      the content
     * @param md2DataStore the md 2 data store
     */
    public AbstractMd2ContentProvider(String key, Md2Entity content, Md2DataStore md2DataStore) {
        this.content = content;

        if (content != null) {
            this.backup = (Md2Entity) content.clone();
        }
        attributeChangedEventHandlers = new HashMap<>();
        //observedAttributes = new HashMap<>();
        this.md2DataStore = md2DataStore;
        this.existsInDataStore = false;
        internalId = -1;
        this.load();
        this.key = key;
    }

    public String getKey() {
        return this.key;
    }

    /**
     * Gets internal id.
     *
     * @return the internal id
     */
    protected long getInternalId() {
        return internalId;
    }

    /**
     * Sets internal id.
     *
     * @param internalId the internal id
     */
    protected void setInternalId(long internalId) {
        this.internalId = internalId;
    }

    @Override
    public Md2Entity getContent() {
        return content;
    }

    @Override
    public void setContent(Md2Entity content) {
        if (content != null) {
            this.content = content;
            this.backup = (Md2Entity) content.clone();
            this.internalId = -1;
            this.load();
        }
    }

    @Override
    public void registerAttributeOnChangeHandler(String attribute, Md2OnAttributeChangedHandler onAttributeChangedHandler) {
        //observedAttributes.put(attribute, this.getValue(attribute));
        attributeChangedEventHandlers.put(attribute, onAttributeChangedHandler);
    }

    @Override
    public void unregisterAttributeOnChangeHandler(String attribute) {
        //this.observedAttributes.remove(attribute);
        this.attributeChangedEventHandlers.remove(attribute);
    }

    @Override
    public Md2OnAttributeChangedHandler getOnAttributeChangedHandler(String attribute) {
        return this.attributeChangedEventHandlers.get(attribute);
    }

    @Override
    public Md2Type getValue(String attribute) {
        if (content != null) {
            return this.content.get(attribute);
        }
        return null;
    }

    @Override
    public void setValue(String attribute, Md2Type value) {
        if (content == null) {
            return;
        }

        // set only if value is different to current value
        if ((this.getValue(attribute) == null && value != null) || !this.getValue(attribute).equals(value)) {
            this.content.set(attribute, value);
            Md2OnAttributeChangedHandler handler = this.attributeChangedEventHandlers.get(attribute);
            if (handler != null) {
                handler.onChange(attribute);
            }
        }
    }

    @Override
    public void reset() {
        if (content == null)
            return;

        Set<String> keys = this.content.getAttributes().keySet();

        for (String key : keys) {
            Md2Type oldValue = this.backup.get(key);
            if (oldValue == null) {
                this.content.getAttributes().remove(key);
            } else {
                this.setValue(key, oldValue);
            }
        }
    }

    @Override
    public void load() {
        if (content == null | md2DataStore == null)
            return;

        // case: entity has id
        if (this.content.getId() > 0) {
            existsInDataStore = true;
            internalId = this.content.getId();
            return;
        }

        // case: entity has no id
        long id = md2DataStore.getInternalId(this.content);
        if (id == -1) {
            existsInDataStore = false;
            internalId = -1;
        } else {
            existsInDataStore = true;
            internalId = id;
            this.content.setId(id);
        }
    }

    @Override
    public void save() {
        if (content == null || md2DataStore == null)
            return;

        if (existsInDataStore)
            md2DataStore.put(internalId, this.content);
        else {
            long newId = md2DataStore.put(this.content);
            if (newId > 0) {
                this.existsInDataStore = true;
                this.internalId = newId;
            }
        }

        this.backup = (Md2Entity) content.clone();
    }

    @Override
    public void remove() {
        if (content == null || md2DataStore == null)
            return;

        md2DataStore.remove(internalId, content);
        internalId = -1;
    }
}
