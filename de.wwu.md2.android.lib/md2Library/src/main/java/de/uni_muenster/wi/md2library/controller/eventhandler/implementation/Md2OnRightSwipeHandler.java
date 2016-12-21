package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import android.content.Context;
import android.view.View;

/**
 * Event handler for right swipe events
 * Related to ElementEventType onRightSwipe in MD2-DSL
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2OnRightSwipeHandler extends AbstractMd2OnSwipeHandler implements View.OnTouchListener {

    /**
     * Instantiates a new Md2 on right swipe handler.
     *
     * @param context the context
     */
    public Md2OnRightSwipeHandler(Context context) {
        super(context);
    }

    @Override
    public boolean onSwipeRight() {
        this.execute();
        return true;
    }

    @Override
    public boolean onSwipeLeft() {
        return false;
    }
}