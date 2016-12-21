package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.interfaces.Md2GlobalEventHandler;

/**
 * Abstract super class for all global event handlers
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2GlobalEventHandler extends AbstractMd2EventHandler implements Md2GlobalEventHandler {
    /**
     * Instantiates a new Abstract md 2 global event handler.
     *
     * @param actions the actions
     */
    public AbstractMd2GlobalEventHandler(ArrayList<Md2Action> actions) {
        super(actions);
    }

    @Override
    public void registerAction(Md2Action action) {
        super.addAction(action);
    }

    @Override
    public void unregisterAction(Md2Action action) {
        super.removeAction(action);
    }
}
