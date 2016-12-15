package de.uni_muenster.wi.md2library.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
import de.uni_muenster.wi.md2library.model.type.implementation.Md2String;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Widget;

/**
 * Created by Fabian on 24.08.2015.
 */

/**
 * Implementation of Label element in MD2-DSL
 * <p/>
 * Created on 24/08/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2Label extends TextView implements Md2Content {

    /**
     * The Widget id.
     */
    protected int widgetId;

    /**
     * The On click handler.
     */
    protected Md2OnClickHandler onClickHandler;
    /**
     * The On changed handler.
     */
    protected Md2OnChangedHandler onChangedHandler;

    /**
     * Instantiates a new Md2 label.
     *
     * @param context the context
     */
    public Md2Label(Context context) {
        super(context);
        this.init();
    }

    /**
     * Instantiates a new Md2 label.
     *
     * @param context the context
     * @param attrs   the attrs
     */
    public Md2Label(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.init();
    }

    /**
     * Instantiates a new Md2 label.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     */
    public Md2Label(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.init();
    }

    /**
     * Instantiates a new Md2 label.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     * @param defStyleRes  the def style res
     */
    public Md2Label(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        this.init();
    }

    /**
     * Copy constructor
     *
     * @param label label to be copied
     */
    private Md2Label(Md2Label label) {
        super(label.getContext());
        this.setWidgetId(label.getWidgetId());
        this.setOnChangedHandler(label.getOnChangedHandler());
        this.setOnClickHandler(label.getOnClickHandler());
        this.setDisabled(label.isDisabled());
        this.setValue(label.getValue());
    }

    /**
     * Initialization
     */
    protected void init() {
        this.setOnChangedHandler(new Md2OnChangedHandler());
        this.setOnClickHandler(new Md2OnClickHandler());
        this.widgetId = -1;
    }

    @Override
    public Md2Type getValue() {
        return new Md2String(super.getText().toString());
    }

    @Override
    public void setValue(Md2Type value) {
        if (value == null) {
            super.setText("");
            return;
        }

        if (!this.getText().equals(value.toString())) {
            super.setText(value.toString());
        }
    }

    @Override
    public Md2OnClickHandler getOnClickHandler() {
        return this.onClickHandler;
    }

    @Override
    public void setOnClickHandler(Md2OnClickHandler onClickHandler) {
        this.onClickHandler = onClickHandler;
        this.setOnClickListener(onClickHandler);
    }

    @Override
    public Md2OnChangedHandler getOnChangedHandler() {
        return this.onChangedHandler;
    }

    @Override
    public void setOnChangedHandler(Md2OnChangedHandler onChangedHandler) {
        this.onChangedHandler = onChangedHandler;
        this.addTextChangedListener(onChangedHandler);
    }

    @Override
    public Md2Widget copy() {
        return new Md2Label(this);
    }

    @Override
    public boolean isDisabled() {
        return !isEnabled();
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
    public boolean equals(Object otherWidget) {
        if (otherWidget == null)
            return false;

        if (!(otherWidget instanceof Md2Label))
            return false;

        Md2Label otherMd2Label = (Md2Label) otherWidget;

        return this.getWidgetId() == otherMd2Label.getWidgetId();
    }
}
