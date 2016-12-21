package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.interfaces.Md2ContentProviderEventHandler;

/**
 * Abstract super class for all content provider event handlers
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2ContentProviderEventHandler extends AbstractMd2EventHandler implements Md2ContentProviderEventHandler {

    /**
     * The Attribute.
     */
    String attribute;

    /**
     * Instantiates a new Abstract md 2 content provider event handler.
     *
     * @param attribute the attribute
     */
    public AbstractMd2ContentProviderEventHandler(String attribute) {
        this(attribute, null);
    }

    /**
     * Instantiates a new Abstract md 2 content provider event handler.
     *
     * @param attribute the attribute
     * @param actions   the actions
     */
    public AbstractMd2ContentProviderEventHandler(String attribute, ArrayList<Md2Action> actions) {
        super(actions);
        this.attribute = attribute;
    }

    /**
     * Gets attribute.
     *
     * @return the attribute
     */
    public String getAttribute() {
        return attribute;
    }

    @Override
    public void registerAction(Md2Action action) {
        super.addAction(action);
    }

    @Override
    public void unregisterAction(Md2Action action) {
        super.removeAction(action);
    }

    @Override
    public void onChange(String attribute) {
        if (attribute.equals(this.attribute)) {
            for (Md2Action action : this.actions) {
                action.execute();
            }
        }
    }
}
