package de.uni_muenster.wi.fabian.md2lib.model.dataStore.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Integer;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Entity;

/**
 * Created by Fabian on 07/07/2015.
 */
public interface DataStore {

    Entity query();
    void put(Entity entity);
    void remove(Integer id);
}
