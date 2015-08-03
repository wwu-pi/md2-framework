package de.uni_muenster.wi.fabian.md2lib.view.widgets.implementation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.EditText;

import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.Boolean;
import de.uni_muenster.wi.fabian.md2lib.model.type.implementation.String;
import de.uni_muenster.wi.fabian.md2lib.model.type.interfaces.Type;
import de.uni_muenster.wi.fabian.md2lib.view.widgets.interfaces.Content;

/**
 * Created by Fabian on 10/07/2015.
 */
public class TextInput extends EditText implements Content {

    protected Boolean isDisabled;
    protected String value;
    protected String widgetId;

    public TextInput(Context context) {
        super(context);
    }

    public TextInput(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public TextInput(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public TextInput(String widgetId, Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    @Override
    public Type getValue() {
        return new String(super.getText().toString());
    }

    @Override
    public void setValue(Type value) {
        super.setText((CharSequence) value.getString().getPlatformValue());
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
