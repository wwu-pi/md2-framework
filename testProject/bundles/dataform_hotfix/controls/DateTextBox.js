define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dijit/form/DateTextBox",
    "./_Control",
    "./DateTimeUtil"
],
    function (declare, d_lang, DateTextBox, _Control, DateTimeUtil) {
        return declare([_Control],
            {
                controlClass: "datetextbox",

                createWidget: function (params) {
                    var constraints = {};
                    // timetextbox react also on undefined values of min or max !
                    var min = DateTimeUtil.toDate(this.min);
                    if (min) {
                        constraints.min = min;
                    }
                    var max = DateTimeUtil.toDate(this.max)
                    if (max) {
                        constraints.max = max;
                    }
                    return new DateTextBox(d_lang.mixin(params, {
                        required: this.required,
                        constraints: constraints
                    }));
                },

                clearBinding: function () {
                    this._updateValue(this.field, undefined, null);
                },

                refreshBinding: function () {
                    var binding = this.dataBinding;
                    var field = this.field;
                    var widget = this.widget;

                    this.connectP("binding", binding, field, "_updateValue");
                    this.connectP("binding", widget, "value", "_storeValue");

                    this._updateValue(field, undefined, binding.get(field));
                },

                _updateValue: function (prop, oldVal, newVal) {
                    var w = this.widget;
                    w.set("valueWithTimeComponent", newVal === null || newVal === undefined ? null : DateTimeUtil.toDate(newVal));
                    w.set("value", newVal === null || newVal === undefined ? null : DateTimeUtil.toDate(newVal));
                },

                _storeValue: function (prop, oldVal, newVal) {
                    if (this.widget.isValid()) {
                        // Only set date part on value. Keep the time part unchanged.
                        if (newVal === undefined) {
                            newVal = null;
                        }
                        if (newVal !== null) {
                            var changedDate = new Date(newVal.getTime());
                            var dateWithTimeComponent = this.widget.get("valueWithTimeComponent");
                            if (dateWithTimeComponent) {
                                changedDate.setHours(dateWithTimeComponent.getHours(), dateWithTimeComponent.getMinutes(), dateWithTimeComponent.getSeconds(), dateWithTimeComponent.getMilliseconds());
                            }
                            newVal = this._getDateValue(changedDate);
                        }
                        this.dataBinding.set(this.field, newVal);
                    }
                },

                _getDateValue: function (value) {
                    var bindingFormat = this.bindingFormat;
                    if (bindingFormat && bindingFormat === "unix") {
                        return new Date(value).getTime();
                    }
                    var isoDate = DateTimeUtil.ensureIsoTime(value, {
                        selector: 'date'
                    });
                    return isoDate;
                }
            });
    });