define(["dojo/_base/lang","dojo/_base/declare","ct/_lang","./_Control","dijit/form/ValidationTextBox"],
    function(d_lang,declare,ct_lang,_Control,ValidationTextBox) {
        /**
        * @fileOverview This is a widget for displaying data of type string.
        */
        return declare([_Control],
        {
            controlClass : "textbox",
            createWidget : function (params) {
                if (params.textboxType){
                    params.type = params.textboxType;
                }
                return new ValidationTextBox(d_lang.mixin(params,{
                    required : this.required,
                    regExp : ct_lang.chk(this.lookupRegEx(this.regex),".*"),
                    maxLength : ct_lang.chk(this.max,255),
                    trim: ct_lang.chk(this.trim,true)
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
                this.widget.set("value",ct_lang.chk(newVal,""));
            },
            _storeValue : function(prop, oldVal, newVal){
                if (this.widget.isValid()){
                    this.dataBinding.set(this.field,ct_lang.chk(newVal,""));
                }
            }
        });
    });