define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "dojo/topic",
    "dojo/string"
],
function(declare, lang, array, topic, string) {
    
    return declare([], {
        
        _identifier: "undefined",
        
        _formControl: null,
        
        _state: undefined,
        
        /**
         * Conatins objects of the following form:
         * {
         *   type: onClick|onChange,
         *   callback: function_reference,
         *   reference: reference to the current event handler of widget,
         *   remove: function that removes the current event
         * }
         */
        _events: undefined,
        
        _validators: undefined,
        
        _onChangeObserver: null,
        
        _defaultValue: undefined,
        
        _datatype: undefined,
        
        _typeFactory: null,
        
        /**
         * Identifier of the topic this wrapper publishes to for onChange
         * events of the widget.
         */
        _topicOnChange: "md2/widget/onChange/${appId}",
        
        constructor: function(identifier, datatype, defaultValue, typeFactory, appId) {
            this._events = [];
            this._validators = [];
            this._state = {
                disabled: false,
                currentValue: null
            };
            
            this._identifier = identifier;
            this._datatype = datatype;
            this._typeFactory = typeFactory;
            this._topicOnChange = string.substitute(this._topicOnChange, {appId: appId});
            
            if(defaultValue !== undefined) {
                this._defaultValue = this._resolveValueType(defaultValue);
                this._state.currentValue = this._resolveValueType(defaultValue);
                this.setValue(this._state.currentValue);
            } else {
                this._state.currentValue = this._resolveValueType(null);
            }
        },
        
        getId: function() {
            return this._identifier;
        },
        
        setWidget: function(formControl) {
            this._formControl = formControl;
            var state = this._state;
            var widget = formControl.widget;
            
            // not all widget can be disabled, e.g. layouts
            widget.setDisabled !== undefined && widget.setDisabled(state.disabled);
            
            // there might be widgets without a value (e.g. buttons, layouts etc.)
            if (widget.value !== undefined) {
                // set value
                state.currentValue && widget.set("value", state.currentValue.getPlatformValue());
                
                // reregister all validators
                array.forEach(this._validators, function(validator) {
                    this.addValidator(validator);
                }, this);
                
                this._onChangeObserver = widget.on("change", lang.hitch(this, function() {
                    this.setValue(this._resolveValueType(widget.get("value")));
                }));
            }
            
            // reregister all events
            array.forEach(this._events, function(event) {
                this._registerEventOnWidget(event);
            }, this);
            
            // set validators
            this._updateWidgetValidator();
            
        },
        
        unsetWidget: function() {
            if (!this._formControl) {
                return;
            }
            this._formControl = null;
            
            if (this._onChangeObserver) {
                this._onChangeObserver.remove();
                this._onChangeObserver = null;
            }
            
            array.forEach(this._events, function(event) {
                event.reference.remove();
                event.reference = null;
            });
        },
        
        /**
         * Returns the currently bound form control. If no form control is bound, return null.
         * @returns {FormControl|null}
         */
        getWidget: function() {
            return this._formControl;
        },
        
        getDefaultValue: function() {
            return this._defaultValue;
        },
        
        getValue: function() {
            return this._state.currentValue;
        },
        
        setValue: function(value) {
            if(!value) {
                return;
            }
            if (this._formControl) {
                var widget = this._formControl.widget;
                widget.set("value", value.getPlatformValue());
            }
            var oldVal = this._state.currentValue;
            this._state.currentValue = value;
            if (!value.equals(oldVal)) {
                topic.publish(this._topicOnChange, this);
            }
        },
        
        setDisabled: function(isDisabled) {
            this._state.disabled = isDisabled;
            if (this._formControl) {
                var widget = this._formControl.widget;
                widget.setDisabled(isDisabled);
            }
        },
        
        isDisabled: function() {
            return this._state.disabled;
        },
        
        /**
         * Allow the validation of widget values even if no dijit widget exists / is displayed.
         * @returns {boolean}
         */
        isValid: function() {
            return array.every(this._validators, function(validator) {
                validator.isValid(this._state.currentValue);
            }, this);
        },
        
        on: function(eventType, callback) {
            var self = this;
            
            /**
             * Internal event object that provides the same interface as the dijit event.
             * Especially the remove method that destroys the dijit widget event as well as
             * this internal event object.
             */
            var event = {
                type: eventType,
                callback: callback,
                reference: undefined,
                remove: function() {
                    this.reference.remove();
                    var removeAtIndex = -1;
                    array.forEach(self._events, function(event, index) {
                        if (event === this) {
                            removeAtIndex = index;
                        }
                    });
                    
                    if (removeAtIndex !== -1) {
                        self._events.splice(removeAtIndex, 1);
                    }
                }
            };
            this._events.push(event);
            this._registerEventOnWidget(event);
        },
        
        addValidator: function(validator) {
            // Lookup whether a validator with the same type already exists.
            // If that is the case, replace current validator. Otherwise, just add the new
            // validator.
            var findIndex = -1;
            array.forEach(this._validators, function(v, index) {
                if (v.getType() === validator.getType()) {
                    findIndex = index;
                    return false;
                }
            });
            if (findIndex !== -1) {
                this._validators[findIndex] = validator;
            } else {
                this._validators.push(validator);
            }
            this._updateWidgetValidator();
        },
        
        removeValidator: function(validatorType) {
            var removeAtIndex = -1;
            array.forEach(this._validators, function(validator, index) {
                if (validator.getType() === validatorType) {
                    removeAtIndex = index;
                }
            });
            if (removeAtIndex !== -1) {
                var validators = this._validators;
                validators.splice(removeAtIndex, 1);
            }
            this._updateWidgetValidator();
        },
        
        _registerEventOnWidget: function(event) {
            if (this._formControl) {
                var widget = this._formControl.widget;
                event.reference = widget.on(event.type, event.callback);
            }
        },
        
        _updateWidgetValidator: function() {
            if (!this._formControl) {
                return;
            }
            
            // overwrite default validator function of dijit widget to use MD2 validators
            var widget = this._formControl.widget;
            var self = this;
            widget.validator = function() {
                var isValid = true;
                var messages = [];
                array.forEach(self._validators, function(validator) {
                    if (!validator.isValid(self._resolveValueType(widget.value))) {
                        isValid = false;
                        messages.push(validator.getMessage());
                    }
                });
                widget.invalidMessage = messages.join("<br />");
                return isValid;
            };
        },
        
        _resolveValueType: function(platformValue) {
            return this._datatype ? this._typeFactory.create(this._datatype, platformValue) : null;
        }
        
    });
});
