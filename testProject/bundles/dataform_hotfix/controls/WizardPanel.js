define([
    "dojo/_base/lang", "ct/array", "dojo/_base/declare", "./_Control", "ct/ui/controls/Wizard", "ct/_lang"
], function(d_lang, ct_array, declare, _Control, Wizard, ct_lang) {

    var emptyfn = function() {
    };
    Wizard = declare([Wizard], {
        _checkButtons: function() {
            if (this._started) {
                var sw = this.selectedChildWidget;
                sw.canGoBack = ct_lang.chk(sw.canGoBack, !sw.isFirstChild);
                sw.doneFunction = this.showDone && ct_lang.chk(sw.showDone, sw.isLastChild) ? emptyfn : null;
                this.inherited(arguments);
            }
        },
        _forward: function() {
            if (!this.checkIsValid({
                selectedWidget: this.selectedChildWidget
            })) {
                return;
            }
            this.forward();
        },
        done: function() {
            if (!this.checkIsValid()) {
                return;
            }
            this.onDone({
                selectedWidget: this.selectedChildWidget
            });
        },
        onDone: function(evt) {
        }

    });
    return declare([_Control], {
        controlClass: "wizardpanel",
        isValid: function() {
            var valid = this.inherited(arguments);
            var invalid = !valid;
            var widget = this.widget;
            var child = widget.selectedChildWidget;
            if (invalid && child) {
                // recheck to test if current selected child is invalid
                invalid = !this._checkValidationState({selectedWidget: child});
            }
            this.widget.set("invalid", invalid)
            return valid;
        },
        createWidget: function(params) {
            var cancelFunction = null;
            if (this.showCancel) {
                cancelFunction = d_lang.hitch(this, "_fireCancel");
            }
            var wizard = new Wizard(d_lang.mixin(params, {
                cancelFunction: cancelFunction,
                showDone: ct_lang.chk(this.showDone, true),
                hideDisabled: ct_lang.chk(this.hideDisabled, true),
                isValid: function() {
                    return true;
                },
                checkIsValid: d_lang.hitch(this, "_checkValidationState")
            }));
            this.connect(wizard, "onDone", this, "_fireDone");
            return wizard;
        },
        _checkValidationState: function(opts) {
            var selectedWidget = opts && opts.selectedWidget;
            if (selectedWidget) {
                var subcontrol = ct_array.arraySearchFirst(this.children, {
                    widget: selectedWidget
                });
                if (subcontrol) {
                    return subcontrol.isValid();
                }
                return true;
            } else {
                return this.isValid();
            }
        },
        _fireDone: function(evt) {
            this.fireEvent("wizardpanel/DONE", evt);
        },
        _fireCancel: function(evt) {
            this.fireEvent("wizardpanel/CANCEL", evt);
        }
    });
});