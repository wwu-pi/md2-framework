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
            var dateDiv = d_domconstruct.create("div", {
                class: "datetimeboxInner"
            });
            var timeDiv = d_domconstruct.create("div", {
                class: "datetimeboxInner"
            });
            var dateWidget = new DateTextBox({});
            var timeWidget = new TimeTextBox({});
            d_domconstruct.place(dateWidget.domNode, dateDiv);
            d_domconstruct.place(timeWidget.domNode, timeDiv);
            d_domconstruct.place(dateDiv, div);
            d_domconstruct.place(timeDiv, div);
            
            dateWidget.on("change", d_lang.hitch(this, this._updateDate));
            timeWidget.on("change", d_lang.hitch(this, this._updateTime));
            
            this._dateWidget = dateWidget;
            this._timeWidget = timeWidget;
            this.domNode = div;
        },
        _updateDate: function() {
            var combinedValue = this._combinedValue || new Date(0);
            var c = combinedValue;
            var d = this._dateWidget.getValue();
            var newVal = d ? new Date(d.getFullYear(), d.getMonth(), d.getDate(), c.getHours(), c.getMinutes(), c.getSeconds()) : null;
            this._combinedValue = newVal;
            this.set("value", newVal);
        },
        _updateTime: function() {
            var combinedValue = this._combinedValue || new Date(0);
            var c = combinedValue;
            var t = this._timeWidget.getValue();
            var newVal = t ? new Date(c.getFullYear(), c.getMonth(), c.getDate(), t.getHours(), t.getMinutes(), t.getSeconds()): null;
            this._combinedValue = newVal;
            this.set("value", newVal);
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