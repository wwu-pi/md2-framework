package de.uni_muenster.wi.md2library.view.management.implementation;

import android.app.Activity;
import android.content.Intent;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Md2ViewManager is used to manage activities.
 * It is used to navigate between views and provides access
 * to widgets of the currently started activity.
 * <p/>
 * <p/>
 * Created on 10/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2ViewManager {
    private static Md2ViewManager instance;

    /**
     * The Active view.
     */
    protected Activity activeView;

    /**
     * Gets instance of the Md2ViewManager.
     * Implemented as singleton.
     *
     * @return the instance
     */
    public static synchronized Md2ViewManager getInstance() {
        if (Md2ViewManager.instance == null) {
            Md2ViewManager.instance = new Md2ViewManager();
        }
        return Md2ViewManager.instance;
    }

    /**
     * Go to specified view, i.e., start respective activity.
     *
     * @param viewName the fully qualified name of the activity that should be started
     */
    public void goTo(String viewName) {
        Class clazz = null;
        try {
            clazz = Class.forName(viewName);
        } catch (ClassNotFoundException e) {
            return;
        }

        Intent intent = new Intent(activeView, clazz);
        activeView.startActivity(intent);
    }

    /**
     * Gets active view.
     *
     * @return the active view
     */
    public Activity getActiveView() {
        return this.activeView;
    }

    /**
     * Sets active view.
     *
     * @param activeView the active view
     */
    public void setActiveView(Activity activeView) {
        this.activeView = activeView;
    }

    /**
     * Gets widget. If the widget belongs to the currently started activity, it is returned directly.
     * Otherwise, the method tries to get the widget from the Md2WidgetRegistry. If the widget has not
     * been created yet, it returns null.
     *
     * @param widgetId the widgetId
     * @return the widget
     */
    public Md2Widget getWidget(int widgetId) {
        Md2Widget widget = (Md2Widget) activeView.findViewById(widgetId);
        return (widget != null) ? widget : Md2WidgetRegistry.getInstance().getWidget(widgetId);
    }

    /**
     * Gets widget value.
     * If the widget is not contained in the currently started activity, the method tries to return the value from the widget stored in the widget registry.
     *
     * @param widgetId the widget id
     * @return the widget value
     */
    public Md2Type getWidgetValue(int widgetId) {
        Md2Content widget = null;

        try {
            widget = (Md2Content) getWidget(widgetId);
        } catch (ClassCastException e) {
            return null;
        }

        return (widget != null) ? widget.getValue() : Md2WidgetRegistry.getInstance().getWidgetValue(widgetId);
    }

    /**
     * Go to initial workflow selection screen
     */
    public void goToStartActivity(){
        this.goTo("md2.mamlproject.StartActivity");
    }
}