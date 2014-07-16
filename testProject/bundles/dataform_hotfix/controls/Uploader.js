define([
    "dojo/_base/lang", "dojox", "dojo/_base/declare", "./_Control", "ct/util/css", "dojox/form/Uploader", "dojox/form/uploader/plugins/IFrame"
], function(d_lang, dojox, declare, _Control, css) {
    /**
     * @fileOverview This is a widget for uploading files.
     */
    return declare([_Control], {
        controlClass: "uploader",
        createWidget: function(params) {
            var label = this._label = this.value || "Place File Here";
            this._uploadedLabel = this.uploadedLabel || "Wait for Server";
            params = d_lang.mixin(params, {
                label: label,
                name: this.name || "file",
                multiple: false,
                uploadOnSelect: true,
                url: this.url
            });
            delete params.value;
            return new dojox.form.Uploader(params);
        },
        refreshBinding: function() {
            var binding = this.dataBinding;
            var dependsOn = this.dependsOnField;
            var widget = this.widget;

            var uploadedLabel = this._uploadedLabel;
            this._orgIconClass = widget.get("iconClass");
            var completed;
            this.connect("binding", widget, "onProgress", function(evt) {
                if (!completed) {
                    widget.set("iconClass", "icon-spinner");
                    widget.set("label", evt.percent === "100%" ? uploadedLabel : evt.percent);
                }
            });
            this.connect("binding", widget, "onBegin", function(evt) {
                completed = false;
                this.fireEvent("uploader/START", {
                    name: evt.name || evt.file || ""
                });
            });
            this.connect("binding", widget, "onComplete", function(evt) {
                completed = true;
                // reset progress info
                this.widget.set({"iconClass": this._orgIconClass, "label": this._label});
                this._storeValue(evt);
            });

            if (dependsOn) {
                this.connectP("binding", binding, dependsOn, "_checkCondition");
                var val = binding.get(dependsOn);
                css.switchHidden(widget.domNode, !val);
            }
        },
        _checkCondition: function(prop, oldVal, newVal) {
            css.switchHidden(this.widget.domNode, !newVal);
        },
        _storeValue: function(evt) {
            var err = evt.error;
            if (err) {
                this.fireEvent("uploader/ERROR", evt);
            } else {
                var val = evt.name || evt.file || "";
                if (this.field) {
                    this.dataBinding.set(this.field, val);
                }
                this.fireEvent("uploader/FINISHED", {
                    name: val
                });
            }
        }
    });
});