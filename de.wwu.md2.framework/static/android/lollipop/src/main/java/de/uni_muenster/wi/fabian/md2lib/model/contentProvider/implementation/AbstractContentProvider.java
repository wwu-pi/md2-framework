package de.uni_muenster.wi.fabian.md2lib.model.contentProvider.implementation;

import java.util.HashMap;

import de.uni_muenster.wi.fabian.md2lib.model.contentProvider.interfaces.ContentProvider;
import de.uni_muenster.wi.fabian.md2lib.model.dataStore.interfaces.DataStore;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Entity;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 10/07/2015.
 */
public abstract class AbstractContentProvider implements ContentProvider {

    protected Entity content;
    protected DataStore dataStore;
    protected HashMap<String, Type> observedAttributes;

    public AbstractContentProvider(Entity content, DataStore dataStore){
        this.content = content;
        this.dataStore = dataStore;
    }

    public AbstractContentProvider(DataStore dataStore){
        this(null, dataStore);
    }

    @Override
    public Entity getContent() {
        return content;
    }

    @Override
    public void setContent(Entity content) {
        this.content = content;
    }

    @Override
    public void registerObservedOnChange(String attribute) {
        observedAttributes.put(attribute,this.getValue(attribute));
    }

    @Override
    public void unregisterObservedOnChange(String attribute) {
        this.observedAttributes.remove(attribute);
    }

    @Override
    public Type getValue(String attribute) {
        return this.content.get(attribute);
    }

    @Override
    public void setValue(String attribute, Type value) {
        // TODO: compare to value and fire OnChangedEvent
        this.content.set(attribute, value);
    }

    @Override
    public void reset() {

    }

    @Override
    public void load() {

    }

    @Override
    public void save() {

    }

    @Override
    public void remove() {

    }
}
