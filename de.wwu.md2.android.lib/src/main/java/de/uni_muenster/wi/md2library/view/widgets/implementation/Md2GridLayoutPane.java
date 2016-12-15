package de.uni_muenster.wi.md2library.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridLayout;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Container;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Implementation of GridLayoutPane element in MD2-DSL
 * TODO: implementation of event handlers
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2GridLayoutPane extends GridLayout implements Md2Container {

    /**
     * The Widget id.
     */
    protected int widgetId;

    /**
     * Instantiates a new Md 2 grid layout pane.
     *
     * @param context the context
     */
    public Md2GridLayoutPane(Context context) {
        super(context);
        init();
    }

    /**
     * Instantiates a new Md 2 grid layout pane.
     *
     * @param context the context
     * @param attrs   the attrs
     */
    public Md2GridLayoutPane(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    /**
     * Instantiates a new Md 2 grid layout pane.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     */
    public Md2GridLayoutPane(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    /**
     * Instantiates a new Md 2 grid layout pane.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     * @param defStyleRes  the def style res
     */
    public Md2GridLayoutPane(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    /**
     * Copy constructor
     *
     * @param gridLayoutPane gridLayoutPane to be copied
     */
    private Md2GridLayoutPane(Md2GridLayoutPane gridLayoutPane) {
        super(gridLayoutPane.getContext());
        this.setWidgetId(gridLayoutPane.getWidgetId());
        this.setDisabled(gridLayoutPane.isDisabled());
    }

    /**
     * Init a button with default values
     */
    protected void init() {
        this.setOnChangedHandler(new Md2OnChangedHandler());
        this.setOnClickHandler(new Md2OnClickHandler());
        this.widgetId = -1;
    }

    @Override
    public boolean isDisabled() {
        return !this.isEnabled();
    }

    @Override
    public void setDisabled(boolean disabled) {
        this.setEnabled(!disabled);
    }

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
        return new Md2GridLayoutPane(this);
    }

    @Override
    public boolean equals(Object otherWidget) {
        if (otherWidget == null)
            return false;

        if (!(otherWidget instanceof Md2GridLayoutPane))
            return false;

        Md2GridLayoutPane otherMd2GridLayoutPane = (Md2GridLayoutPane) otherWidget;

        return this.getWidgetId() == otherMd2GridLayoutPane.getWidgetId();
    }
}
