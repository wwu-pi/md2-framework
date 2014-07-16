define(["dojo/_base/declare", "ct/_lang", "dojo/_base/array","ct/array", "dijit/form/RadioButton", "dataform/controls/_Control"],
function(declare, ct_lang, d_array,ct_array, RadioButton, _Control) {
    /*
     * COPYRIGHT 2014 con terra GmbH Germany
     */
    /**
     * @fileOverview This is a radiobutton widget.
     */
    return declare([_Control],
            {
                controlClass: "radiobutton",
                createWidget: function(params) {
                    //HTML-Name attribute is used to group RadioButtons
                    if (params.groupId) {
                      params.name = params.groupId;
                    } else{
                        params.name=params.field;
                    }
                    return new RadioButton(params);
                },
                clearBinding: function() {
                    this._updateValue(this.field, undefined, false);
                },
                refreshBinding: function() {
                    var binding = this.dataBinding;
                    var field = this.field;
                    var widget = this.widget;

                    this._value = ct_lang.chk(this.value, true);

                    this.connectP("binding", binding, field, "_updateValue");
                    this.connectP("binding", widget, "checked", "_storeValue");

                    this._updateValue(field, undefined, binding.get(field));
                },
                _updateValue: function(prop, oldVal, newVal) {
                    var dataType = typeof (newVal);
                    var value = this._value;
                    var checked = false;
                    if (dataType === "boolean" || (typeof (value) === "boolean")) {
                        checked = value === newVal;
                    } else if (dataType === "string") {
                        checked = d_array.indexOf(newVal.split(","), value) > -1;
                    } else if (dataType === "object" || dataType === "undefined") {
                        checked = d_array.indexOf(newVal || [], value) > -1;
                    }
                    this.widget.set("checked", checked);
                },
                _storeValue: function(prop, oldChecked, newChecked) {
                    var noDataTypeCheck = this.noDataTypeCheck;
                    var fieldValue = this.dataBinding.get(this.field);
                    var dataType = typeof (fieldValue);
                    var value = this._value;
                    var arr;
                    if (noDataTypeCheck) {
                        fieldValue = newChecked ? value : this.uncheckedValue;
                    } else if (dataType === "boolean" || (value === true)){
                        fieldValue = newChecked;
                    }else if (dataType === "string"){
                        arr = !fieldValue? [] : fieldValue.split(",");
                        if (newChecked){
                            //remove all and add only the new one;
                            arr=[];
                            ct_array.arrayAdd(arr, value);
                        }else{
                            ct_array.arrayRemove(arr, value);
                        }
                        fieldValue = arr.join(",");
                    }else if (dataType === "object" || dataType === "undefined"){
                        arr = (fieldValue||[]).slice(0);
                        if (newChecked){
                            //remove all and add only the new one; 
                            arr=[];
                            ct_array.arrayAdd(arr, value);
                        }else{                           
                            ct_array.arrayRemove(arr, value);
                        }
                        fieldValue = arr;
                    }
                    this.dataBinding.set(this.field, fieldValue);
                }
            });
});