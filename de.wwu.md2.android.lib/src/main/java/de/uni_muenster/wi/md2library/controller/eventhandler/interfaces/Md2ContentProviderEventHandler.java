package de.uni_muenster.wi.md2library.controller.eventhandler.interfaces;

/**
 * Content provider Event handler interface that is implemented by all
 * content provider event handlers.
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2ContentProviderEventHandler extends Md2EventHandler {
    /**
     * On change.
     *
     * @param attribute the changed attribute
     */
    void onChange(String attribute);
}
