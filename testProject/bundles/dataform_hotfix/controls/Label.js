define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "ct/array",
    "dojo/dom-construct",
    "./_Control",
    "dijit/_Widget",
    "ct/util/TypeFormat"
],
    function (d_lang, declare, ct_array, d_domconstruct, _Control, _Widget, TypeFormat) {
        /**
         * @fileOverview This is a widget for displaying data of type string.
         */
        var Label = declare([_Widget], {
            placeHolder: null,
            _setLabelAttr: function (value) {
                var domNode = this.domNode;
                domNode.innerHTML = value || this.placeHolder || "";
            },

            buildRendering: function () {
                this.domNode = d_domconstruct.create("span");
            }
        });
        var multifieldsregex = /\{[\w\.]+\}/;
        return declare([_Control],
            {
                controlClass: "label",
                createWidget: function (params) {
                    return new Label(d_lang.mixin(params, {
                        label: this.value || this.title || ""
                    }));
                },
                clearBinding: function () {
                    this._updateLabelValue();
                },
                refreshBinding: function () {
                    var binding = this.dataBinding;
                    var field = this.field;
                    var value = this.value;
                    this._updateLabelValue();
                    if (field) {
                        this.connectP("binding", binding, field, "_updateValue");
                    } else if (value && (multifieldsregex.test(value))) {
                        var that = this;
                        d_lang.replace(value, function (n) {
                            that.connectP("binding", binding, n.substr(1, n.length - 2), "_updateValue");
                        });
                    }
                },
                _updateValue: function (prop, oldVal, newVal) {
                    this._updateLabelValue();
                },
                _updateLabelValue: function () {
                    var binding = this.dataBinding || {
                        get: function () {
                        }
                    };
                    var field = this.field;

                    var fieldType = this.fieldType;
                    var formatter = TypeFormat[fieldType] || function (x) {
                        return x
                    };
                    var value;
                    if (field) {
                        value = binding.get(field);
                        if (value !== undefined) {
                            if (this.lookupValues) {
                                value = this._lookupValue(value);
                            } else {
                                value = formatter(value);
                            }
                        } else {
                            value = "";
                        }
                    } else {
                        value = this.value;
                        if (value && (multifieldsregex.test(value))) {
                            value = d_lang.replace(value, function (n) {
                                return formatter(binding.get(n.substr(1, n.length - 2)) || "");
                            });
                        }
                    }
                    this.widget.set("label", value || "");
                },

                _lookupValue: function (value) {
                    var lookup = this.lookupValues;
                    if (lookup) {
                        var item = ct_array.arraySearchFirst(lookup, function(item) {
                            return item.value === value;
                        });
                        if (item) {
                            value = item.name;
                        }
                    }
                    return value;
                }
            });
    });