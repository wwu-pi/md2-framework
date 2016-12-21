package de.uni_muenster.wi.md2library.model.dataStore.interfaces;

/**
 * Interface definition for a remote data store factory.
 * <p/>
 * Created on 14/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2RemoteDataStoreFactory extends Md2DataStoreFactory {

    /**
     * Get remote data store.
     *
     * @param uri    the uri
     * @param entity the entity
     * @return the data store
     */
    Md2DataStore getDataStore(String uri, String entity);
}
