define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/topic"
],
function(declare, lang, array, topic) {
    return declare([], {
        
        _refs: null,
        
        _customEventTriggers: {},
        
        /////////////////////////////////////////////////////////////////////
        // Register application specific custom events
        /////////////////////////////////////////////////////////////////////
        
        constructor: function(customEvents, references) {
            this._refs = references;
            customEvents.$ = this;
            customEvents.register();
            this._listen(customEvents);
        },
        
        /**
         * Adds event callbacks for a custom event to the hash object. Each field that is accessed
         * in the condition of the custom event has to be observed. Changes to any of the form fields
         * trigger a check of the custom condition.
         */
        observe: function() {
            var callback = arguments[arguments.length - 1];
            for(var i = 0; i < arguments.length - 1; i++) {
                var arg = arguments[i];
                this._customEventTriggers[arg] = this._customEventTriggers[arg] || [];
                this._customEventTriggers[arg].push(callback);
            }
        },
        
        get: function(dataFormField) {
            var mapping = this._refs.dataMapper.getMapping(dataFormField);
            return mapping.unvalidatedWidgetValue;
        },
        
        isValid: function(dataFormField) {
            var mapping = this._refs.dataMapper.getMapping(dataFormField);
            return mapping.formControl && mapping.formControl.widget.isValid();
        },
        
        fire: function(eventName) {
            topic.publish("md2/customEvent/" + eventName);
        },
        
        _listen: function(scope) {
            topic.subscribe("md2/dataFieldMapper/newUnvalidatedValue", lang.hitch(this, function(dataFormField) {
                var triggers = this._customEventTriggers[dataFormField];
                if(triggers) {
                    array.forEach(triggers, function(callback) {
                        callback.call(scope);
                    });
                }
            }));
        }
        
    });
});
