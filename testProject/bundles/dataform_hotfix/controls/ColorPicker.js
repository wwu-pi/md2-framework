define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "ct/ui/controls/forms/DropDownColorSelector",
    "dojox/widget/ColorPicker",
    "dojo/dom-style",
    "./_Control"
    ],
    function(declare, d_lang, DropDownColorSelector, ColorPicker, domStyle, _Control) {
        /*
        * COPYRIGHT 2013 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a color picker widget.
        */
        return declare([_Control],
        {
            controlClass : "colorpicker",

            createWidget : function (params) {
                var colorPicker;
                if (params.asDropDown) {
                    params = d_lang.mixin(params, {
                        colorSelectionWidgetClass: ColorPicker,
                        showInTooltipDialog: true
                    });
                    colorPicker = new DropDownColorSelector(params);
                } else {
                    colorPicker = new ColorPicker(params);
                }
                return colorPicker;
            },

            clearBinding : function() {
                this._updateValue(this.field);
            },

            refreshBinding : function() {
                var binding = this.dataBinding;
                var field = this.field;
                var colorPicker = this.widget;
                this.connectP("binding", binding, field, this, "_updateValue");
                this.connect("binding", colorPicker, "onChange", this, function() {
                    this._storeValue("value", undefined, this.widget.get("value"));
                });

                this._updateValue(field, undefined, binding.get(field));
            },

            _updateValue : function(prop, oldVal, newVal){
                var colorPicker = this.widget;
                colorPicker.set("value", newVal || "#000000");
            },

            _storeValue : function(prop, oldVal, newVal){
                this.dataBinding.set(this.field, newVal);
            }
        });
    });