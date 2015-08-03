package de.uni_muenster.wi.fabian.md2lib.model.contentProvider.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Entity;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 10/07/2015.
 */
public interface ContentProvider {
    Entity getContent();
    void setContent(Entity content);
    void registerObservedOnChange(String attribute);
    void unregisterObservedOnChange(String attribute);
    Type getValue(String attribute);
    void setValue(String attribute, Type value);
    void reset();
    void load();
    void save();
    void remove();
}
