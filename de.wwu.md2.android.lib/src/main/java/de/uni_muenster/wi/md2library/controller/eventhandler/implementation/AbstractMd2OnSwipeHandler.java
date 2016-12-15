package de.uni_muenster.wi.md2library.controller.eventhandler.implementation;

import android.content.Context;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;

/**
 * Abstract super class for swipe event handlers.
 * Extended by Md2OnLeftSwipeHandler and Md2OnRightSwipeHandler
 * <p/>
 * Created on 11/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public abstract class AbstractMd2OnSwipeHandler extends AbstractMd2WidgetEventHandler implements View.OnTouchListener {

    private final GestureDetector gestureDetector;

    /**
     * Instantiates a new Abstract md 2 on swipe handler.
     *
     * @param context the context
     */
    public AbstractMd2OnSwipeHandler(Context context) {
        super();
        gestureDetector = new GestureDetector(context, new GestureListener());
    }

    /**
     * On swipe right boolean.
     *
     * @return the boolean
     */
// these must be overwritten by concrete onLeftSwipe and onRightSwipe Handlers
    public abstract boolean onSwipeRight();

    /**
     * On swipe left boolean.
     *
     * @return the boolean
     */
    public abstract boolean onSwipeLeft();

    public boolean onTouch(View v, MotionEvent event) {
        return gestureDetector.onTouchEvent(event);
    }

    private final class GestureListener extends GestureDetector.SimpleOnGestureListener {

        private static final int SWIPE_DISTANCE_THRESHOLD = 100;
        private static final int SWIPE_VELOCITY_THRESHOLD = 100;

        @Override
        public boolean onDown(MotionEvent e) {
            return true;
        }

        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
            float distanceX = e2.getX() - e1.getX();
            float distanceY = e2.getY() - e1.getY();
            if (Math.abs(distanceX) > Math.abs(distanceY) && Math.abs(distanceX) > SWIPE_DISTANCE_THRESHOLD && Math.abs(velocityX) > SWIPE_VELOCITY_THRESHOLD) {
                if (distanceX > 0)
                    return onSwipeRight();
                else
                    return onSwipeLeft();
            }
            return false;
        }
    }
}
