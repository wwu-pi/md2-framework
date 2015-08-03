package de.uni_muenster.wi.fabian.md2lib.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;
import de.uni_muenster.wi.fabian.md2lib.view.widgets.interfaces.Container;

/**
 * Created by Fabian on 10/07/2015.
 */
public class FlowLayoutPane extends LinearLayout implements Container{

    protected Boolean isDisabled;
    protected String widgetId;

    public FlowLayoutPane(Context context) {
        super(context);
    }

    public FlowLayoutPane(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public FlowLayoutPane(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public FlowLayoutPane(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    @Override
    public void setDisabled(Boolean isDisabled) {
        this.isDisabled = isDisabled;
    }

    @Override
    public Boolean isDisabled() {
        return this.isDisabled;
    }

    @Override
    public String getWidgetId(){
        return this.widgetId;
    }

    @Override
    public void setWidgetId(String widgetId){
        this.widgetId = widgetId;
    }
}
