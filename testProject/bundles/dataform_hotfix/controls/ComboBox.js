define(["dojo/_base/lang","dojo/_base/declare","ct/_lang","dijit/form/ComboBox","dijit/form/FilteringSelect","./_Control","ct/store/ComplexMemory","ct/store/SuggestQueryStore","ct/store/AttributeExtender"],
    function(d_lang,declare,ct_lang,ComboBox,FilteringSelect,_Control,ComplexMemory,SuggestQueryStore,AttributeExtender) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a combo box widget, like a select box, but you can enter values not present in the store.
        */
        return declare([_Control],
        {
            controlClass : "combobox",
            createWidget : function (params) {
                var _getValueField = function(){
                    // prefer store id Property!
                    return this.valueAttr || this.store.idProperty || this.searchAttr;
                };
                        
                if (this.onlyPreDefinedValues){
                    return new FilteringSelect(d_lang.mixin(params,{
                        required : this.required,
                        store : SuggestQueryStore(new ComplexMemory()),
                        _getValueField : _getValueField
                    }));
                }
                return new ComboBox(d_lang.mixin(params,{
                    required : this.required,
                    regExp : ct_lang.chk(this.lookupRegEx(this.regex),".*"),
                    maxLength : ct_lang.chk(this.max,255),
                    trim: ct_lang.chk(this.trim,true),
                    store : SuggestQueryStore(new ComplexMemory()),
                    _getValueField : _getValueField
                }));
            },
            clearBinding : function(){
                this._updateValue(this.field, undefined, "");
                this.widget.set("store",SuggestQueryStore(new ComplexMemory()));
            },
            refreshBinding : function(){
                var binding = this.dataBinding;
                var field = this.field;
                var widget = this.widget;
                var store = this.getStore() || new ComplexMemory();

                var searchAttr = this.searchAttribute || store.idProperty;
                var labelAttr = this.labelAttribute || searchAttr;
                var labelAttrDefs = [];
                if (labelAttr.indexOf("${")>-1){
                    var attrName = "__lableAttr";
                    labelAttrDefs = [{
                        name : attrName,
                        value: labelAttr,
                        // automatic sort if ${} syntax is used!
                        descending: false
                    }];
                    labelAttr = attrName;
                }
                widget.set({
                    "store": AttributeExtender(SuggestQueryStore(store),labelAttrDefs),
                    "searchAttr": searchAttr,
                    "labelAttr": labelAttr
                });

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