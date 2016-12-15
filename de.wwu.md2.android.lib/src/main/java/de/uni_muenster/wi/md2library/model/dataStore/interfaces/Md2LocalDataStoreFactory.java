package de.uni_muenster.wi.md2library.model.dataStore.interfaces;

/**
 * Created by Fabian on 21.09.2015.
 */
public interface Md2LocalDataStoreFactory extends Md2DataStoreFactory {

    /**
     * Gets data store.
     *
     * @param entity the entity
     * @return the data store
     */
    Md2LocalStore getDataStore(String entity);
}
