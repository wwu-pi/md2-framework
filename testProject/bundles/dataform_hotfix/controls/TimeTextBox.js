define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dijit/form/TimeTextBox",
    "./_Control",
    "./DateTimeUtil"
],
    function (d_lang, declare, TimeTextBox, _Control, DateTimeUtil) {

        return declare([_Control],
            {
                controlClass: "timetextbox",

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
                    var timePattern = this.pattern;
                    if (timePattern) {
                        constraints.timePattern = timePattern;
                    }
                    var inc = DateTimeUtil.ensureIsoTime(this.inc, {
                        selector: 'time',
                        noMarkedZulu: true
                    });
                    var visibleinc;
                    var visiblerange;
                    if (inc) {
                        // changed increment (calculate default range and visible inc settings)
                        var d = DateTimeUtil.toDate(inc, {
                            noMarkedZulu: true
                        });
                        visibleinc = DateTimeUtil.ensureIsoTime(d * 4, {
                            selector: 'time',
                            noMarkedZulu: true
                        });
                        visiblerange = DateTimeUtil.ensureIsoTime(d * 10, {
                            selector: 'time',
                            noMarkedZulu: true
                        });
                        constraints.clickableIncrement = inc;
                    }
                    // Note: direct setting of visibleinc and visiblerange should rarely be used!
                    // The default values calculated based on inc, should be sufficient
                    visibleinc = DateTimeUtil.ensureIsoTime(this.visibleinc, {
                        selector: 'time',
                        noMarkedZulu: true
                    }) || visibleinc;
                    if (visibleinc) {
                        constraints.visibleIncrement = visibleinc;
                    }
                    visiblerange = DateTimeUtil.ensureIsoTime(this.visiblerange, {
                        selector: 'time',
                        noMarkedZulu: true
                    }) || visiblerange;
                    if (visiblerange) {
                        constraints.visibleRange = visiblerange;
                    }
                    return new TimeTextBox(d_lang.mixin(params, {
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
                    var widget = this.widget;
                    widget.set("valueWithDateComponent", newVal === null || newVal === undefined ? null : DateTimeUtil.toDate(newVal));
                    widget.set("value", newVal === null || newVal === undefined ? null : DateTimeUtil.toDate(newVal));
                },

                _storeValue: function (prop, oldVal, newVal) {
                    if (this.widget.isValid()) {
                        if (newVal === undefined) {
                            newVal = null;
                        }
                        if (newVal !== null) {
                            // Only set time part on value. Keep the date part unchanged.
                            var changedDate = new Date(newVal.getTime());
                            var dateWithDateComponent = this.widget.get("valueWithDateComponent");
                            if (dateWithDateComponent) {
                                changedDate.setFullYear(dateWithDateComponent.getFullYear(), dateWithDateComponent.getMonth(), dateWithDateComponent.getDate());
                            }
                            newVal = this._getTimeValue(changedDate);
                        }
                        this.dataBinding.set(this.field, newVal);
                    }
                },

                _getTimeValue: function (value) {
                    var bindingFormat = this.bindingFormat;
                    if (bindingFormat && bindingFormat === "unix") {
                        return new Date(value).getTime();
                    }
                    return DateTimeUtil.ensureIsoTime(value, {
                        selector: 'time',
                        zulu: true
                    });
                }
            });
    });