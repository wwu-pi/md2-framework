package de.uni_muenster.wi.md2library.controller.eventhandler.interfaces;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Md2 Event handler interface that is implemented by all event handlers.
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2EventHandler {
    /**
     * Executes all actions registered in the event handler.
     */
    void execute();

    /**
     * Register action.
     *
     * @param action the action
     */
    void registerAction(Md2Action action);

    /**
     * Unregister action.
     *
     * @param action the action
     */
    void unregisterAction(Md2Action action);
}
