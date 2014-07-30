define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dojo/dom-construct",
    "dataform/controls/_Control",
    "dijit/_WidgetBase",
    "dijit/Tooltip"
],
function (d_lang, declare, d_domconstruct, _Control, _WidgetBase, Tooltip) {
    
    var TooltipIcon = declare([_WidgetBase], {
        
        _setValueAttr: function(value) {
            this.labelValue = value || "";
            if(this.tooltip) {
                this.tooltip.label = this.labelValue;
            }
        },
        
        buildRendering: function () {
            var inner = d_domconstruct.create("div", {class: "icon-info"});
            var outer = d_domconstruct.create("div", {class: "md2-tooltipicon"});
            d_domconstruct.place(inner, outer);
            this.domNode = outer;
        },
        
        postCreate: function() {
            this.tooltip = new Tooltip({
                connectId: [this.domNode],
                label: this.labelValue
            });
        }
    });
    
    var TooltipControl = declare([_Control], {
        
        controlClass: "tooltipicon",
        
        createWidget: function(params) {
            return new TooltipIcon(d_lang.mixin(params, {
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
    
    return declare([], /** @lends dataform.controls.FormControlFactory.prototype */{
        
        createFormControl: function(widgetParams) {
            return new TooltipControl(widgetParams);
        }
        
    });
});