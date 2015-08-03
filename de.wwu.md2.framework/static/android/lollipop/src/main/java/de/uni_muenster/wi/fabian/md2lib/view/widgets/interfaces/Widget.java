package de.uni_muenster.wi.fabian.md2lib.view.widgets.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 10/07/2015.
 */
public interface Widget {
    void setDisabled(Boolean isDisabled);
    Boolean isDisabled();
    String getWidgetId();
    void setWidgetId(String widgetId);
}
