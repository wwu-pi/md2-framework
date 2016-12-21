package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.interfaces.Md2EventHandler;


/**
 * Abstract super class for all event handlers
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2EventHandler implements Md2EventHandler {
    /**
     * The Actions.
     */
    protected ArrayList<Md2Action> actions;

    /**
     * Instantiates a new Abstract md 2 event handler.
     */
    public AbstractMd2EventHandler() {
        actions = new ArrayList<Md2Action>();
    }

    /**
     * Instantiates a new Abstract md 2 event handler.
     *
     * @param actions the actions
     */
    public AbstractMd2EventHandler(ArrayList<Md2Action> actions) {
        if (actions == null) {
            this.actions = new ArrayList<Md2Action>();
        } else {
            this.actions = new ArrayList<Md2Action>(actions);
        }
    }

    /**
     * Gets actions.
     *
     * @return the actions
     */
    protected ArrayList<Md2Action> getActions() {
        return this.actions;
    }

    /**
     * Add action.
     *
     * @param action the action
     */
    protected void addAction(Md2Action action) {
        if (actions.contains(action))
            return;


        actions.add(action);
    }

    /**
     * Remove action.
     *
     * @param action the action
     */
    protected void removeAction(Md2Action action) {
        actions.remove(action);
    }

    @Override
    public void execute() {
        for (Md2Action action : getActions()) {
            action.execute();
        }
    }
}
