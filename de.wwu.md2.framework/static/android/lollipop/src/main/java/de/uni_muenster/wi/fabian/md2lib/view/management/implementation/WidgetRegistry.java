package de.uni_muenster.wi.fabian.md2lib.view.management.implementation;

import java.util.HashMap;
import java.util.Map;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.*;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;
import de.uni_muenster.wi.fabian.md2lib.view.widgets.interfaces.Widget;

/**
 * Created by Fabian on 10/07/2015.
 */
public class WidgetRegistry {

    Map<String, Widget> widgets = new HashMap<>();

    WidgetRegistry(){
        widgets = new HashMap<>();
    }

    public void add(Widget widget){
        widgets.put(widget.getWidgetId(), widget);
    }

    public Widget getWidget(String widgetId){
        return widgets.get(widgetId);
    }
}
