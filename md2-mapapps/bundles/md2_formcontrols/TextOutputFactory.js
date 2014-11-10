define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dataform/controls/_Control",
    "dijit/_WidgetBase"
],
function (d_lang, declare, d_domconstruct, _Control, _WidgetBase) {
    /**
     * @fileOverview This is a widget for displaying data of type string.
     */
    var TextOutput = declare([_WidgetBase], {
        _setValueAttr: function(value) {
            var domNode = this.domNode;
            domNode.innerHTML = value || "";
        },
        buildRendering: function () {
            this.domNode = d_domconstruct.create("span");
        }
    });
    
    var TextOutputControl = declare([_Control], {
        controlClass: "textoutput",
        createWidget: function(params) {
            return new TextOutput(d_lang.mixin(params, {
                label: this.value || this.title || "",
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
    
    /**
     * Actual dataform.ControlFactory interface implementation.
     * @param {Object} widgetParams
     * @returns {TextOutputControl}
     */
    return declare([], {
        createFormControl: function(widgetParams) {
            return new TextOutputControl(widgetParams);
        }
    });
});