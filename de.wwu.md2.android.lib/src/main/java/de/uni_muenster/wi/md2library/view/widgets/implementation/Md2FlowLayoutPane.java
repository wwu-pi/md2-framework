package de.uni_muenster.wi.md2library.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Container;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Implementation of FlowLayoutPane element in MD2-DSL
 * TODO: implementation of event handlers
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2FlowLayoutPane extends LinearLayout implements Md2Container {

    /**
     * The Widget id.
     */
    protected int widgetId;

    /**
     * Instantiates a new Md2 flow layout pane.
     *
     * @param context the context
     */
    public Md2FlowLayoutPane(Context context) {
        super(context);
        init();
    }

    /**
     * Instantiates a new Md2 flow layout pane.
     *
     * @param context the context
     * @param attrs   the attrs
     */
    public Md2FlowLayoutPane(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    /**
     * Instantiates a new Md2 flow layout pane.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     */
    public Md2FlowLayoutPane(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    /**
     * Instantiates a new Md2 flow layout pane.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     * @param defStyleRes  the def style res
     */
    public Md2FlowLayoutPane(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    /**
     * Copy constructor
     *
     * @param flowLayoutPane flowLayoutPane to be copied
     */
    private Md2FlowLayoutPane(Md2FlowLayoutPane flowLayoutPane) {
        super(flowLayoutPane.getContext());
        this.setDisabled(flowLayoutPane.isDisabled());
        this.setWidgetId(flowLayoutPane.getWidgetId());
    }

    /**
     * Init with default values
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
        return new Md2FlowLayoutPane(this);
    }

    @Override
    public boolean equals(Object otherWidget) {
        if (otherWidget == null)
            return false;

        if (!(otherWidget instanceof Md2FlowLayoutPane))
            return false;

        Md2FlowLayoutPane otherMd2FlowLayoutPane = (Md2FlowLayoutPane) otherWidget;

        return this.getWidgetId() == otherMd2FlowLayoutPane.getWidgetId();
    }
}
