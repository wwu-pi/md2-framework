package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import android.text.Editable;
import android.text.TextWatcher;

import java.util.ArrayList;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Event handler for on-change events.
 * Related to ElementEventType onChange in MD2-DSL.
 * Implements the interface TextWatcher
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2OnChangedHandler extends AbstractMd2WidgetEventHandler implements TextWatcher {
    /**
     * Instantiates a new Md 2 on changed handler.
     */
    public Md2OnChangedHandler() {
        super();
    }

    /**
     * Instantiates a new Md 2 on changed handler.
     *
     * @param actions the actions
     */
    public Md2OnChangedHandler(ArrayList<Md2Action> actions) {
        super(actions);
    }

    // TextWatcher
    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }

    @Override
    public void afterTextChanged(Editable s) {
        this.execute();
    }
}
