define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/topic", "dojo/date/stamp"
],

/**
 * 
 */
function(declare, lang, array, topic, stamp) {
    return declare([], {
        
        /**
         * Maps a dataFormField (view) to a tuple of the form ["contentProviderName", "propertyName", formControlReference].
         * With propertyName being the actual property/attribute of the object that is managed by the contentProvider.
         * 
         * The mappings are organized by viewNames, e.g. the dataFormField startView$outerPanel$firstName (that is mapped
         * to the content provider with the name "customerContentProvider" and its managed attribute first name), is stored as
         * follows:
         * _mapping: {
         *   startView: {
         *     startView$outerPanel$firstName: ["customerContentProvider", "firstName", firstNameControlRef]
         *   }
         * }
         */
        _mapping: {},
        
        _contentProviderRegistry: null,
        
        /**
         * Maps the views to the data form bindings
         */
        _dataFormBindings: {},
        
        _currentView: null,
        
        constructor: function(contentProviderRegistry) {
            this._contentProviderRegistry = contentProviderRegistry;
        },
        
        bindDataForm: function(viewName, dataFormWidget) {
            var binding = dataFormWidget.dataFormService.createBinding("object", {data: {}});
            dataFormWidget.set("dataBinding", binding);
            this._dataFormBindings[viewName] = binding;
            
            // observer: pass changes in the data form fields to the according content providers
            binding.watch("*", lang.hitch(this, this._onChange));
            
            // map all formControls to the data field names
            this._addFormControlToMapping(dataFormWidget.bodyControl);
            
            // Populate the dataForm widget with the current values of the mapped content providers.
            // Ensures that the initial data object contains all mapped fields (e.g. if fields were mapped
            // before the data form was bound).
            var dataFormFields = this._mapping[viewName] || {};
            for(var dataFormField in dataFormFields) {
                if(!dataFormFields.hasOwnProperty(dataFormField)) {
                    continue;
                }
                var mapping = this.getMapping(dataFormField);
                mapping.hasMapping && binding.set(dataFormField, mapping.propertyValue);
            }
            
            return this;
        },
        
        setCurrentView: function(viewName) {
            this._currentView = viewName;
            return this;
        },
        
        /**
         * Update all data in the currently bound data form with the data from the
         * passed content provider.
         * 
         * @param {string} contentProviderName - Populate bound fields with data from content provider.
         */
        updateDataForm: function(contentProviderName) {
            var view = this._currentView;
            var bindings = this._dataFormBindings;
            
            if(!view || !bindings[view]) {
                console && console.warn("MD2DataFieldMapper: Current view not set or no bindings defined for view.");
                return this;
            }
            
            var data = bindings[view].data;
            
            for(var dataFormField in data) {
                if(!data.hasOwnProperty(dataFormField)) {
                    continue;
                }
                var mapping = this.getMapping(dataFormField);
                if(mapping.hasMapping && (!contentProviderName || mapping.contentProviderName === contentProviderName)) {
                    bindings[view].set(dataFormField, mapping.propertyValue);
                } else if(!mapping.hasMapping && !contentProviderName) {
                    bindings[view].set(dataFormField, null);
                }
            }
            
            return this;
        },
        
        getMapping: function(dataFormField) {
            var view = dataFormField.split("$", 1)[0];
            var viewTarget = this._mapping[view];
            var mapping = viewTarget ? viewTarget[dataFormField]: null;
            var registry = this._contentProviderRegistry;
            var contentProvider = mapping && mapping[0] ? registry.getContentProvider(mapping[0]) : null;
            
            return mapping ? {
                self: mapping,
                contentProvider: contentProvider,
                contentProviderName: mapping[0],
                propertyName: mapping[1],
                propertyValue: contentProvider ? contentProvider.getContent()[mapping[1]] : null,
                formControl: mapping[2],
                unvalidatedWidgetValue: mapping[2] ? this._getFormattedValue(mapping[2].widget) : null,
                hasMapping: !!mapping[0],
                hasFormControl: !!mapping[2]
            } : {
                hasMapping: false,
                hasFormControl: false
            };
        },
        
        map: function(dataFormField, contentProviderName, propertyName) {
            var view = dataFormField.split("$", 1)[0];
            
            // add mapping
            if(!this._mapping[view]) {
                this._mapping[view] = {};
            }
            this._mapping[view][dataFormField] = this._mapping[view][dataFormField] || [];
            this._mapping[view][dataFormField][0] = contentProviderName;
            this._mapping[view][dataFormField][1] = propertyName;
            
            // update current data form
            var binding = this._dataFormBindings[view];
            if(binding) {
                var contentProvider = this._contentProviderRegistry.getContentProvider(contentProviderName);
                var entity = contentProvider.getContent();
                binding.set(dataFormField, entity[propertyName]);
            }
            return this;
        },
        
        unmap: function(dataFormField, contentProviderName, propertyName) {
            var mapping = this.getMapping(dataFormField);
            var view = dataFormField.split("$", 1)[0];
            
            var cond1 = !mapping.hasMapping;
            var cond2 = contentProviderName && mapping.contentProviderName !== contentProviderName;
            var cond3 = propertyName && mapping.propertyName !== propertyName;
            
            if(cond1 || cond2 || cond3) {
                return this;
            }
            
            if(!mapping.hasFormControl) {
                delete this._mapping[view][dataFormField];
            } else {
                mapping.self[0] = null;
                mapping.self[1] = null;
            }
            return this;
        },
        
        /**
         * Map all dataFormControl->Widget objects for the current widget by recursively
         * iterating through the children.
         * 
         * @param {_Control} formControl
         */
        _addFormControlToMapping: function(formControl) {
            array.forEach(formControl.children, function(childControl) {
                try {
                    if(childControl.field) {
                        var dataFormField = childControl.field;
                        var view = dataFormField.split("$", 1)[0];
                        
                        this._mapping[view] = this._mapping[view] || {};
                        this._mapping[view][dataFormField] = this._mapping[view][dataFormField] || [];
                        this._mapping[view][dataFormField][2] = childControl;
                        this._watchFormControlChanges(childControl);
                        this._appendExtendedValidator(childControl);
                    }
                } catch(err) {
                    console & console.error("MD2DataFieldMapper: Unexpected error on form control mapping!", err);
                }
                this._addFormControlToMapping(childControl);
            }, this);
        },
        
        /**
         * Watch unvalidated changes in a data form field.
         * 
         * @param {type} formControl
         * @returns {undefined}
         */
        _watchFormControlChanges: function(formControl) {
            var dataFormField = formControl.field;
            var widget = formControl.widget;
            widget.on("change", lang.hitch(this, function() {
                var val = this._getFormattedValue(widget);
                topic.publish("md2/dataFieldMapper/newUnvalidatedValue", dataFormField, val);
            }));
        },
        
        /**
         * Get unvalidated value from form widget.
         * 
         * @param {type} widget
         * @returns {Boolean|String}
         */
        _getFormattedValue: function(widget) {
            var val;
            switch(widget.declaredClass) {
                case "dijit.form.DateTextBox":
                    val = widget.get("value");
                    val = val ? stamp.toISOString(val, {selector: "date"}) : val;
                    break;
                case "dijit.form.TimeTextBox":
                    val = widget.get("value");
                    val = val ? stamp.toISOString(val, {selector: "time"}) : val;
                    break;
                case "dijit.form.CheckBox":
                    val = widget.get("value") ? true : false;
                    break;
                default:
                    val = widget.get("value");
            }
            return val;
        },
        
        _appendExtendedValidator: function(formControl) {
            formControl.widget._defaultValidator = formControl.widget.validator;
            formControl.widget.validator = function(v, c) {
                var isNumeric = !c.isNumericCheck || !v || v.match(/^-?\d*(\.\d+)?$/i);
                var isInteger = !c.isIntegerCheck || !v || v.match(/^-?\d*$/i);
                var isDate = !c.isDateCheck || !v /* TODO data format check */;
                var isMin = true;//!c.min || !v || isNumeric && v >= c.min;
                var isMax = true;//!c.max || !v ||isNumeric && v <= c.max;
                var isMinLength = !c.minLength || !v || v.length >= c.minLength;
                var isMaxLength = !c.maxLength || !v || v.length <= c.maxLength;
                
                return this._defaultValidator(v, c)
                        && isNumeric && isInteger && isDate
                        && isMin && isMax && isMinLength && isMaxLength;
            };
        },
        
        /**
         * Watch data binding changes.
         * 
         * @param {string} dataFormField
         * @param {string} oldVal
         * @param {string} newVal
         */
        _onChange: function(dataFormField, oldVal, newVal) {
            if(newVal === oldVal) {
                return;
            }
            var mapping = this.getMapping(dataFormField);
            var isValid = !mapping.hasFormControl || !mapping.formControl.widget.isValid || mapping.formControl.widget.isValid();
            if(mapping.hasMapping && mapping.propertyValue !== newVal && isValid) {
                var obj = {};
                obj[mapping.propertyName] = newVal;
                mapping.contentProvider.setContent(obj);
                this.updateDataForm(mapping.contentProviderName);
            }
        }
        
    });
});
