package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
import de.uni_muenster.wi.md2library.controller.eventhandler.interfaces.Md2ContentProviderEventHandler;

/**
 * Event handler for on-change events in content providers.
 * Related to ContentProviderEventType onChange in MD2-DSL.
 * <p/>
 * Created on 12/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2OnAttributeChangedHandler extends AbstractMd2ContentProviderEventHandler implements Md2ContentProviderEventHandler {
    /**
     * Instantiates a new Md 2 on attribute changed handler.
     *
     * @param attribute the attribute
     */
    public Md2OnAttributeChangedHandler(String attribute) {
        super(attribute);
    }

    /**
     * Instantiates a new Md 2 on attribute changed handler.
     *
     * @param attribute the attribute
     * @param actions   the actions
     */
    public Md2OnAttributeChangedHandler(String attribute, ArrayList<Md2Action> actions) {
        super(attribute, actions);
    }
}
