package de.uni_muenster.wi.fabian.md2lib.view.management.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;

/**
 * Created by Fabian on 12.07.2015.
 */
public interface ViewManager {

    void goTo(String viewName);

    void setupView(String viewName);
}
