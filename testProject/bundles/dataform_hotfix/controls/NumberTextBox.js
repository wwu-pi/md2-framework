define(["dojo/_base/lang","dojo/_base/declare","./_Control","dijit/form/NumberTextBox","ct/_lang"],
    function(d_lang,declare,_Control,NumberTextBox,ct_lang) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a widget for displaying data of type NumberField.
        */
        return declare([_Control],
        {
            controlClass : "numbertextbox",
            createWidget : function (params) {
                return new NumberTextBox(d_lang.mixin(params,{
                    required : this.required,
                    constraints : {
                        min : this.min,
                        max : this.max,
                        places : this.places,
                        fractional : ct_lang.chk(this.fractional,this.places!==0)
                    }
                }));
            },
            clearBinding : function(){
                this._updateValue(this.field);
            },
            refreshBinding : function(){
                var binding = this.dataBinding;
                var field = this.field;
                var widget = this.widget;
                this.connectP("binding",binding,field,"_updateValue");
                this.connectP("binding",widget,"value","_storeValue");
                this._updateValue(field, undefined, binding.get(field));
            },
            _updateValue : function(prop, oldVal, newVal){
                this.widget.set("value",newVal);
            },
            _storeValue : function(prop, oldVal, newVal){
                if (this.widget.isValid()){
                    if(isNaN(newVal)){
                        newVal = undefined;
                    }
                    this.dataBinding.set(this.field,newVal);
                }
            }
        });
    });