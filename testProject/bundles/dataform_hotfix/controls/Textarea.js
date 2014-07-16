define([
    "dojo/_base/lang", "dojo/_base/declare", "ct/_lang", "./_Control", "dijit/form/ValidationTextBox", "dijit/form/SimpleTextarea", "dojo/dom-geometry", "dojo/json"
], function(d_lang, declare, ct_lang, _Control, ValidationTextBox, SimpleTextarea, domGeometry, JSON) {
    /**
     * @fileOverview This is a widget for displaying data of type string.
     */
    var ValidationTextarea = declare([ValidationTextBox, SimpleTextarea], {
        resize: function(dim) {
            if (dim && dim.w && dim.h) {
                domGeometry.setMarginBox(this.domNode, dim);
            }
        },
        isValid: function() {
            if (!this.inherited(arguments)) {
                return false;
            }
            if (this.isJson) {
                var val = this.get("value");
                if (!val && !this.required) {
                    return true;
                }
                try {
                    JSON.parse(val);
                } catch (e) {
                    return false;
                }
            }
            return true;
        }

    });

    return declare([_Control], {
        controlClass: "textarea",
        createWidget: function(params) {
            var style;
            if (!ct_lang.chk(this.resizeable, false)) {
                style = {
                    'resize': 'none'
                };
            }
            return new ValidationTextarea(d_lang.mixin(params, {
                required: this.required,
                regExp: ct_lang.chk(this.lookupRegEx(this.regex), "[\\s\\S]*"),
                rows: ct_lang.chk(this.rows, ""),
                cols: ct_lang.chk(this.cols, ""),
                maxLength: ct_lang.chk(this.max, ""),
                trim: ct_lang.chk(this.trim, false),
                wrap: ct_lang.chk(this.wrap, "off"),
                style: style
            }));
        },
        clearBinding: function() {
            this._updateValue(this.field);
        },
        refreshBinding: function() {
            var binding = this.dataBinding;
            var field = this.field;
            var widget = this.widget;

            this.connectP("binding", binding, field, "_updateValue");
            this.connectP("binding", widget, "value", "_storeValue");

            this._updateValue(field, undefined, binding.get(field));
        },
        _updateValue: function(prop, oldVal, newVal) {
            var isJson = this._isJson = this.isJson || (newVal!==null && (typeof (newVal) === 'object'));
            if (isJson) {
                newVal = JSON.stringify(newVal, undefined, " ");
            }
            // isJson is used in isValid
            this.widget.set("isJson", isJson);
            this.widget.set("value", ct_lang.chk(newVal, ""));
        },
        _storeValue: function(prop, oldVal, newVal) {
            if (this.widget.isValid()) {
                if (this._isJson) {
                    if (newVal === "") {
                        newVal = undefined;
                    } else {
                        newVal = JSON.parse(newVal);
                    }
                } else {
                    newVal = ct_lang.chk(newVal, "");
                }
                this.dataBinding.set(this.field, newVal);
            }
        }
    });
});