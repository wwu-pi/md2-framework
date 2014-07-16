define(["dojo/_base/lang", "dojo/_base/declare", "./_Control", "dijit/form/Button"],
        function(d_lang, declare, _Control, Button) {
            /**
             * @fileOverview This is a button widget.
             */
            return declare([_Control], {
                controlClass: "button",
                createWidget: function(params) {
                    var button = new Button(d_lang.mixin(params, {
                        label: this.value || this.title || this.label || "",
                        iconClass: this.iconClass
                    }));
                    button.on("click", d_lang.hitch(this, "_fireClick"));
                    return button;
                },
                _fireClick: function(evt) {
                    this.fireEvent(this.topic || "button/CLICK", evt);
                }
            });
        });