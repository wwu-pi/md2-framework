define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dataform/controls/_Control",
    "dijit/_WidgetBase",
    "dijit/form/DateTextBox",
    "dijit/form/TimeTextBox"
],
function (d_lang, declare, d_domconstruct, _Control, _WidgetBase, DateTextBox, TimeTextBox) {
    /**
     * @fileOverview This is a widget for displaying data of type string.
     */
    var DateTimeBox = declare([_WidgetBase], {
        _setValueAttr: function(value) {
            this._dateWidget.setValue(value);
            this._timeWidget.setValue(value);
        },
        buildRendering: function () {
            var div = d_domconstruct.create("div");
            var dateWidget = new DateTextBox();
            var timeWidget = new TimeTextBox();
            d_domconstruct.place(dateWidget.domNode, div);
            d_domconstruct.place(timeWidget.domNode, div);
            this._dateWidget = dateWidget;
            this._timeWidget = timeWidget;
            this.domNode = div;
        }
    });
    
    var DateTimeBoxControl = declare([_Control], {
        controlClass: "datetimebox",
        createWidget: function(params) {
            return new DateTimeBox(d_lang.mixin(params, {
                value: this.defaultText
            }));
        },
        
        clearBinding: function() {
            this._updateValue(this.field, undefined, undefined);
        },
        
        refreshBinding: function() {
            var binding = this.dataBinding;
            var field = this.field;
            var widget = this.widget;
            
            this.connectP("binding", binding, field, "_updateValue");
            this._updateValue(field, undefined, binding.get(field));
        },
        
        _updateValue: function (prop, oldVal, newVal) {
            var w = this.widget;
            w.set("value", newVal === null || newVal === undefined ? this.defaultText : newVal);
        }
    });
    
    return declare([], /** @lends dataform.controls.FormControlFactory.prototype */{
        
        createFormControl: function(widgetParams) {
            return new DateTimeBoxControl(widgetParams);
        }
    });
});