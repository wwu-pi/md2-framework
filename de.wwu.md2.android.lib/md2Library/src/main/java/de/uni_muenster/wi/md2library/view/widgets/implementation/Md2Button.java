package de.uni_muenster.wi.md2library.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;

import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
import de.uni_muenster.wi.md2library.model.type.implementation.Md2String;
import de.uni_muenster.wi.md2library.model.type.interfaces.Md2Type;
import de.uni_muenster.wi.md2library.view.widgets.interfaces.Md2Content;

/**
 * Implementation of a Button element in MD2-DSL
 * <p/>
 * Created on 10/07/2015
 *
 * @author Fabian Wrede
 * @version 1.0
 * @since 1.0
 */
public class Md2Button extends android.widget.Button implements Md2Content {

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
     * Instantiates a new Md2 button.
     *
     * @param context the context
     */
    public Md2Button(Context context) {
        super(context);
        this.init();
    }

    /**
     * Instantiates a new Md2 button.
     *
     * @param context the context
     * @param attrs   the attrs
     */
    public Md2Button(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.init();
    }

    /**
     * Instantiates a new Md2 button.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     */
    public Md2Button(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.init();
    }

    /**
     * Instantiates a new Md2 button.
     *
     * @param context      the context
     * @param attrs        the attrs
     * @param defStyleAttr the def style attr
     * @param defStyleRes  the def style res
     */
    public Md2Button(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        this.init();
    }

    /**
     * Copy constructor
     *
     * @param button button to be copied
     */
    private Md2Button(Md2Button button) {
        super(button.getContext());
        this.setWidgetId(button.getWidgetId());
        this.setOnChangedHandler(button.getOnChangedHandler());
        this.setOnClickHandler(button.getOnClickHandler());
        this.setDisabled(!button.isDisabled());
        this.setValue(button.getValue());
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
    public Md2Type getValue() {
        return new Md2String(super.getText().toString());
    }

    @Override
    public void setValue(Md2Type value) {
        if (value == null) {
            this.setText("");
            return;
        }

        Md2String oldValue = (Md2String) this.getValue();
        super.setText(value.toString());

        if (!value.equals(oldValue)) {
            this.getOnChangedHandler().execute();
        }
    }

    @Override
    public Md2OnClickHandler getOnClickHandler() {
        return this.onClickHandler;
    }

    @Override
    public void setOnClickHandler(Md2OnClickHandler onClickHandler) {
        this.setOnClickListener(onClickHandler);
        this.onClickHandler = onClickHandler;
    }

    @Override
    public Md2OnChangedHandler getOnChangedHandler() {
        return this.onChangedHandler;
    }

    @Override
    public void setOnChangedHandler(Md2OnChangedHandler onChangedHandler) {
        this.onChangedHandler = onChangedHandler;
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
    public boolean equals(Object otherWidget) {
        if (otherWidget == null)
            return false;

        if (!(otherWidget instanceof Md2Button))
            return false;

        Md2Button otherMd2Button = (Md2Button) otherWidget;

        return this.getWidgetId() == otherMd2Button.getWidgetId();
    }

    @Override
    public Md2Button copy() {
        return new Md2Button(this);
    }
}
