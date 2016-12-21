package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import android.view.MotionEvent;
import android.view.View;

import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

/**
 * Event handler for onClick events.
 * Related to ElementEventType onClick in MD2-DSL.
 * Implements the interface View.OnClickListener and View.OnTouchListener
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2OnClickHandler extends AbstractMd2WidgetEventHandler implements View.OnClickListener, View.OnTouchListener {

    /**
     * Instantiates a new Md 2 on click handler.
     */
    public Md2OnClickHandler() {
        super();
    }

    @Override
    public void onClick(View v) {
        this.execute();
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_UP:
                this.execute();
                return true;
        }
        return false;
    }

    @Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        result.append("MD2OnClickHandler: #Actions = " + getActions().size() + "; ");
        for (Md2Action action : getActions()) {
            result.append(action.getActionSignature() + "; ");
        }
        return result.toString();
    }
}
