define(["dojo/_base/declare","ct/_lang","dojo/_base/array","ct/array","ct/_equal","dijit/form/CheckBox","./_Control"],
    function(declare,ct_lang,d_array,ct_array,ct_equal,CheckBox,_Control) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a checkbox widget.
        */
        return declare([_Control],
        {
            controlClass : "checkbox",
            createWidget : function (params) {
                return new CheckBox(params);
            },

            clearBinding : function(){
                this._updateValue(this.field, undefined, false);
            },

            refreshBinding : function(){
                var binding = this.dataBinding;
                var field = this.field;
                var widget = this.widget;

                this._value = ct_lang.chk(this.value,true);

                this.connectP("binding",binding,field,"_updateValue");
                this.connectP("binding",widget,"checked","_storeValue");

                this._updateValue(field, undefined, binding.get(field));
            },
            _updateValue : function(prop, oldVal, newVal){
                var noDataTypeCheck = this.noDataTypeCheck;
                var dataType = typeof(newVal);
                var value = this._value;
                var checked = false;
                if (noDataTypeCheck || (dataType === "boolean" || (typeof(value) === "boolean"))){
                    checked = ct_equal.equals(value, newVal);
                }else if (dataType === "string"){
                    checked = d_array.indexOf(newVal.split(","),value)>-1
                }else if (dataType === "object" || dataType === "undefined"){
                    // array
                    checked = d_array.indexOf(newVal||[],value)>-1
                }
                this.widget.set("checked",checked);
            },
            _storeValue : function(prop, oldChecked, newChecked){
                var noDataTypeCheck = this.noDataTypeCheck;
                var fieldValue = this.dataBinding.get(this.field);
                var dataType = typeof(fieldValue);
                var value = this._value;
                var arr;
                if (noDataTypeCheck) {
                    fieldValue = newChecked ? value : this.uncheckedValue;
                } else if (dataType === "boolean" || (value === true)){
                    fieldValue = newChecked;
                }else if (dataType === "string"){
                    arr = !fieldValue? [] : fieldValue.split(",");
                    if (newChecked){
                        ct_array.arrayAdd(arr, value);
                    }else{
                        ct_array.arrayRemove(arr, value);
                    }
                    fieldValue = arr.join(",");
                }else if (dataType === "object" || dataType === "undefined"){
                    // array
                    arr = (fieldValue||[]).slice(0);
                    if (newChecked){
                        ct_array.arrayAdd(arr, value);
                    }else{
                        ct_array.arrayRemove(arr, value);
                    }
                    fieldValue = arr;
                }
                this.dataBinding.set(this.field,fieldValue);
            }
        });
    });