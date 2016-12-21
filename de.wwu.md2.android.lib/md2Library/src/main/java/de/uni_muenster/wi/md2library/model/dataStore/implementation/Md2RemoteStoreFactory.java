package de.uni_muenster.wi.md2library.model.dataStore.implementation;

import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2DataStore;
import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2RemoteDataStoreFactory;

/**
 * Created by Fabian on 09/07/2015.
 */
public class Md2RemoteStoreFactory extends AbstractMd2DataStoreFactory implements Md2RemoteDataStoreFactory {

    @Override
    public Md2DataStore getDataStore(String uri, String entity) {
        return null;
    }
}
