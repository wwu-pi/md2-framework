package de.uni_muenster.wi.md2library.view.widgets.interfaces;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;

/**
 * Represents ViewGUIElements in MD2-DSL.
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public interface Md2Widget {

    /**
     * Gets widget id.
     *
     * @return the widget id
     */
    int getWidgetId();

    /**
     * Sets widget id.
     *
     * @param widgetId the widget id
     */
    void setWidgetId(int widgetId);

    /**
     * Gets disabled.
     *
     * @return the disabled boolean
     */
    boolean isDisabled();

    /**
     * Sets disabled.
     *
     * @param disabled the disabled boolean
     */
    void setDisabled(boolean disabled);

    /**
     * Gets on click handler.
     *
     * @return the on click handler
     */
    Md2OnClickHandler getOnClickHandler();

    /**
     * Sets on click handler.
     *
     * @param onClickHandler the on click handler
     */
    void setOnClickHandler(Md2OnClickHandler onClickHandler);

    /**
     * Gets on changed handler.
     *
     * @return the on changed handler
     */
    Md2OnChangedHandler getOnChangedHandler();

    /**
     * Sets on changed handler.
     *
     * @param onChangedHandler the on changed handler
     */
    void setOnChangedHandler(Md2OnChangedHandler onChangedHandler);

    /**
     * Copy Md2Widget.
     *
     * @return copy of the Md2Widget
     */
    Md2Widget copy();
}
