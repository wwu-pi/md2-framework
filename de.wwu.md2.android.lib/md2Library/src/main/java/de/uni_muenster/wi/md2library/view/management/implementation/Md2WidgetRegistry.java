package de.uni_muenster.wi.md2library.view.management.implementation;

import java.util.HashMap;
import java.util.Map;

import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Md2WidgetRegistry is used to store widgets of the MD2 application.
 * It is used by activities during their lifecycle.
 * <p/>
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2WidgetRegistry {

    private static Md2WidgetRegistry instance;

    /**
     * The Widgets.
     */
    Map<Integer, Md2Widget> widgets = new HashMap<>();

    private Md2WidgetRegistry() {
        widgets = new HashMap<>();
    }

    /**
     * Gets instance of the Md2WidgetRegistry.
     * Implemented as a singleton.
     *
     * @return the instance
     */
    public static synchronized Md2WidgetRegistry getInstance() {
        if (Md2WidgetRegistry.instance == null)

        {
            Md2WidgetRegistry.instance = new Md2WidgetRegistry();
        }
        return Md2WidgetRegistry.instance;
    }

    /**
     * Add widget.
     * Called by Activities' onCreate.
     *
     * @param widget the widget
     */
    public void addWidget(Md2Widget widget) {
        if (widgets.containsKey(widget.getWidgetId()))
            return;

        widgets.put(widget.getWidgetId(), widget.copy());
    }

    /**
     * Load widget.
     * Called by Activities' onStart.
     *
     * @param widget the widget
     */
    public void loadWidget(Md2Widget widget) {
        Md2Widget savedWidget = widgets.get(widget.getWidgetId());

        if (savedWidget == null)
            return;

        widget.setOnClickHandler(savedWidget.getOnClickHandler());
        widget.setOnChangedHandler(savedWidget.getOnChangedHandler());

        try {
            Md2Content content = (Md2Content) widget;
            Md2Content savedContent = (Md2Content) savedWidget;
            Md2Type value = savedContent.getValue();
            content.setValue(value);
        } catch (ClassCastException e) {
            // it is a container and has no value
            // could use a check with instanceof instead
        }
    }

    /**
     * Save widget.
     * Called by Activities' onPause.
     *
     * @param widget the widget
     */
    public void saveWidget(Md2Widget widget) {
        widgets.put(widget.getWidgetId(), widget.copy());
    }

    /**
     * Gets widget.
     * Code of a generated application should use the getWidget method of the Md2ViewManager!
     * This method is only used by the Md2ViewManager.
     *
     * @param widgetId the widget id
     * @return the widget value
     */
    public Md2Widget getWidget(int widgetId) {
        return this.widgets.containsKey(widgetId) ? this.widgets.get(widgetId) : null;
    }

    /**
     * Gets widget value.
     * Code of a generated application should use the getWidgetValue method of the Md2ViewManager!
     * This method is used by the Md2ViewManager.
     *
     * @param widgetId the widget id
     * @return the widget value
     */
    public Md2Type getWidgetValue(int widgetId) {
        try {
            return this.widgets.containsKey(widgetId) ? ((Md2Content) this.widgets.get(widgetId)).getValue() : null;
        } catch (ClassCastException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        result.append("Md2WidgetRegistry: ");
        for (Map.Entry entry : widgets.entrySet()) {
            result.append("(Key: " + entry.getKey() + ", Value: " + entry.getValue() + ");");
        }

        return result.toString();
    }
}
