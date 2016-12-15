package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.interfaces.Md2WidgetEventHandler;

/**
 * Abstract super class for all widget event handlers
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2WidgetEventHandler extends AbstractMd2EventHandler implements Md2WidgetEventHandler {

    /**
     * Instantiates a new Abstract md 2 widget event handler.
     */
    public AbstractMd2WidgetEventHandler() {
        super();
    }

    /**
     * Instantiates a new Abstract md 2 widget event handler.
     *
     * @param actions the actions
     */
    public AbstractMd2WidgetEventHandler(ArrayList<Md2Action> actions) {
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
