define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/dom-geometry", "dojo/dom-class", "ct/Stateful", "ct/_Connect", "ct/store/ComplexMemory", "dijit/Tooltip", "./RegExLookup"
], function(declare, d_lang, d_array, domGeometry, domClass, Stateful, _Connect, ComplexMemory, Tooltip, RegExLookup) {
    /**
     * @fileOverview Provides base class for simpler control implementation.
     */
    return declare([Stateful, _Connect], {
        constructor: function(params) {
            // all parameters are mixed in, but here we keep the original state
            this.params = params || {};
            this.children = [];
        },
        // abstract method, must be implemented by sub classes
        //createWidget : function(){},
        refreshBinding: function() {
        },
        clearBinding: function() {
        },
        /**
         * Data binding
         * @param {Object} databinding the data access abstraction.
         */
        _setDataBinding: function(binding) {
            this.disconnect("binding");
            this.clearBinding();
            this.dataBinding = binding;
            if (binding) {
                this.refreshBinding();
            }
            this._applyBindingToChildren(binding);
        },
        _applyBindingToChildren: function(binding) {
            d_array.forEach(this.children, function(c) {
                c.set("dataBinding", binding);
            });
        },
        isValid: function() {
            var widget = this.widget;
            var isValid = true;
            if (widget && widget.isValid) {
                isValid = widget.isValid();
            }
            return isValid && d_array.every(this.children, function(c) {
                return c.isValid();
            });
        },
        /**
         * used to broad cast events.
         */
        _setRootWidget: function(w) {
            this.rootWidget = w;
            d_array.forEach(this.children, function(c) {
                c.set("rootWidget", w);
            });
        },
        // gets wrapped dojo widget
        _getWidget: function() {
            var that = this;
            return this.widget || (this.widget = (function() {
                var params = that.params;
                params.label = params.label || params.title;
                params.labelTitle = params.title;
                delete params.title;
                var w = that.createWidget(params);
                var styleClasses = ["ctFormControl"];
                var controlClass = that.controlClass;
                if (controlClass) {
                    styleClasses.push(controlClass);
                }
                var cssClass = that.cssClass;
                if (cssClass) {
                    styleClasses.push(cssClass);
                }
                var node = w.domNode;
                domClass.add(node, styleClasses);
                if (params.tooltip) {
                    var tooltip = new Tooltip({
                        connectId: [node],
                        label: params.tooltip
                    });
                    tooltip.connect(w, "destroy", "destroyRecursive");
                }
                // connect to "state" property -> used to fire /dataform/validationStateChanged event
                var watchHandle = w.watch("state", function() {
                    that.fireEvent(that.rootWidget._topicValidationStateChanged);
                });
                w.connect(w, "destroy", function() {
                    watchHandle.unwatch();
                });
                return w;
            })());
        },
        addControl: function(control, size) {
            var w = control.get("widget");
            this._resize(w, size);
            var cw = this.get("widget");
            if (cw.addChild) {
                cw.addChild(w);
            } else {
                w.placeAt(cw.containerNode || cw.domNode);
            }
            this.children.push(control);
        },
        resize: function(size) {
            this._resize(this.get("widget"), size);
        },
        _resize: function(w, size) {
            if (!size) {
                return;
            }
            var pos = size.l || size.t || size.b || size.r;
            if (pos !== undefined) {
                domClass.add(w.domNode, "hasposition");
            }else{
                domClass.remove(w.domNode, "hasposition");
            }
            if (w.resize) {
                domGeometry.setMarginBox(w.domNode, size);
                w.resize(size);
            } else {
                domGeometry.setMarginBox(w.domNode, size);
            }
            this.size = size;
        },
        // controls should use this method to broadcast events
        // to form listeners
        fireEvent: function(topic, evtParams) {
            // set by data form
            var rootWidget = this.rootWidget;
            if (rootWidget) {
                evtParams = evtParams || {};
                evtParams.control = this;
                evtParams.topic = topic;
                rootWidget._fireEvent(evtParams);
            }
        },
        getStore: function() {
            var values = this.values;
            if (values) {
                var fieldDesc = {
                    "valueAttr": "value"
                };
                if (!(values instanceof Array) && values.field) {
                    d_lang.mixin(fieldDesc, values);
                    var field = values.field;
                    values = this.dataBinding.get(field);
                    if (!values) {
                        return undefined;
                    }
                    //TODO: add store support
                }
                return new ComplexMemory({
                    idProperty: fieldDesc.valueAttr,
                    data: d_array.map(values, function(val) {
                        if (typeof (val) !== 'object') {
                            var value = val;
                            val = {
                                "name": val
                            };
                            val[fieldDesc.valueAttr] = value;
                        }
                        return val;
                    })
                });
            }
            var storeId = this.store;
            if (storeId) {
                var rootWidget = this.rootWidget;
                if (!rootWidget) {
                    console.error("getStore: store with id '" + storeId + "' is searched before root widget is registered!");
                    return undefined;
                }
                var entry = rootWidget._resolveStoreEntry(storeId);
                if (!entry) {
                    console.warn("getStore: store with id '" + storeId + "' can't be resolved!");
                    return undefined;
                }
                return entry.store;
            }
            return undefined;
        },
        lookupRegEx: function(regExOrKey) {
            return RegExLookup[regExOrKey] || regExOrKey;
        }
    });
});