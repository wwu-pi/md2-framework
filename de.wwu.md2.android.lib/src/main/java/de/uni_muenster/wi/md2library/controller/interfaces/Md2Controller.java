package de.uni_muenster.wi.md2library.controller.interfaces;

import de.uni_muenster.wi.md2library.model.dataStore.interfaces.Md2SQLiteHelper;

/**
 * Interface definition for controller that is generated in MD2 application
 * <p/>
 * Created on 12/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Controller {

    /**
     * Perform setup of the application
     */
    void run();

    /**
     * Gets md2 sqlite helper.
     *
     * @return the Md2SQLiteHelper
     */
    Md2SQLiteHelper getMd2SQLiteHelper();
}
