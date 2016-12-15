package de.uni_muenster.wi.md2library.view.widgets.implementation;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Container;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * TODO: Implement TabbedPane
 * Implementation of TabbedPane element in MD2-DSL
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 */
public class Md2TabbedPane implements Md2Container {
    /**
     * The Widget id.
     */
    protected int widgetId;

    /**
     * The Disabled.
     */
    protected boolean disabled;

    @Override
    public boolean isDisabled() {
        return this.disabled;
    }

    @Override
    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }

    @Override
    public int getWidgetId() {
        return this.widgetId;
    }

    @Override
    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }

    @Override
    public Md2OnClickHandler getOnClickHandler() {
        return null;
    }

    @Override
    public void setOnClickHandler(Md2OnClickHandler onClickHandler) {

    }

    @Override
    public Md2OnChangedHandler getOnChangedHandler() {
        return null;
    }

    @Override
    public void setOnChangedHandler(Md2OnChangedHandler onChangedHandler) {

    }

    @Override
    public Md2Widget copy() {
        return null;
    }
}
