define(["dojo/_base/declare","ct/_lang","dojox/mobile/Switch","./_Control"],
    function(declare,ct_lang,Switch,_Control) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a checkbox widget.
        */
        return declare([_Control],
        {
            controlClass : "switch",
            createWidget : function (params) {
                return new Switch(params);
            },

            clearBinding : function(){
                this._updateValue(this.field, undefined, false);
            },

            refreshBinding : function(){
                var binding = this.dataBinding;
                var field = this.field;
                var widget = this.widget;

                this._value = ct_lang.chk(this.value, "off");

                this.connectP("binding",binding,field,"_updateValue");
                this.connect("binding", widget, "onStateChanged", "_storeValue");

                this._updateValue(field, undefined, binding.get(field));
            },
            _updateValue : function(prop, oldVal, newVal){
                var value = (newVal) ? "on" : "off";
                this.widget.set("value",value);
            },
            _storeValue : function(prop){
                var fieldValue = (prop==="on") ? true : false;
                this.dataBinding.set(this.field,fieldValue);
            }
        });
    });