package de.uni_muenster.wi.md2library.model.dataStore.implementation;

import de.uni_muenster.wi.md2library.controller.interfaces.Md2Controller;
import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2LocalDataStoreFactory;
import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2LocalStore;

/**
 * {@inheritDoc}
 * <p/>
 * <p/>
 * Created on 09/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2LocalStoreFactory extends AbstractMd2DataStoreFactory implements Md2LocalDataStoreFactory {
    /**
     * The controller of a MD2 application.
     */
    Md2Controller controller;

    /**
     * The fully qualified factory name of a data store factory that is implemented by a user in the MD2 application
     */
    String fullyQualifiedFactoryName;

    /**
     * Instantiates a new Md2 local store factory.
     *
     * @param controller the controller
     */
    public Md2LocalStoreFactory(Md2Controller controller) {
        this(controller, null);
    }

    /**
     * Instantiates a new Md2 local store factory.
     *
     * @param controller                the controller
     * @param fullyQualifiedFactoryName the fully qualified factory name
     */
    public Md2LocalStoreFactory(Md2Controller controller, String fullyQualifiedFactoryName) {
        this.controller = controller;
        this.fullyQualifiedFactoryName = fullyQualifiedFactoryName;
    }

    /**
     * Instantiates a new Md2 local store factory.
     * If a custom data store factory is implemented in a MD2 application, the factory is used first.
     * default location: {rootpackage}/md2/model/dataStore/LocalDataStoreFactory
     *
     * @param entity the name of the entity managed by the content provider the data store is associated with
     */
    @Override
    public Md2LocalStore getDataStore(String entity) {
        if (fullyQualifiedFactoryName == null || fullyQualifiedFactoryName.isEmpty())
            return new Md2SQLiteDataStore(controller.getMd2SQLiteHelper());

        try {
            Md2LocalStoreFactory factory = (Md2LocalStoreFactory) Class.forName(fullyQualifiedFactoryName).newInstance();
            Md2LocalStore localStore = factory.getDataStore(entity);
            return (localStore != null) ? localStore : new Md2SQLiteDataStore(controller.getMd2SQLiteHelper());
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | ClassCastException e) {
            return new Md2SQLiteDataStore(controller.getMd2SQLiteHelper());
        }
    }
}