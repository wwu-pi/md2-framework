package de.uni_muenster.wi.fabian.md2lib.view.widgets.interfaces;

import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;

/**
 * Created by Fabian on 10/07/2015.
 */
public interface Content extends Widget{
    Type getValue();
    void setValue(Type value);
}
