define([
    "dojo/_base/declare", "ct/_lang", "./_Type"
], function(declare, ct_lang, _Type) {
    
    return declare([_Type], {
        
        _datatype: "undefined",
        
        /**
         * Enum object of the format:
         * {
         *   "VALUE0": "This is a string",
         *   "VALUE2": "This is another string",
         *   .
         *   .
         *   .
         * }
         */
        _enum: null,
        
        toString: function() {
            return this._platformValue ? this._enum[this._platformValue] : this._enum["VALUE0"];
        },
        
        isSet: function() {
            return !!this._platformValue;
        },
        
        /**
         * Creates a data array of all enum entries to be used by dojo Memory store
         * in SelectBoxes.
         * @returns {Array} Array with id-name tuples that represent options of a select.
         */
        getOptions: function() {
            var options = [];
            ct_lang.forEachOwnProp(this._enum, function(value, name) {
                options.push({
                    value: name,
                    name: value
                });
            }, this);
            return options;
        },
        
        _castFromString: function(value) {
            if (!value.match(/VALUE\d+/)) {
                return ct_lang.getFirstOwnPropNameWithValue(this._enum, value);
            } else {
                return value;
            }
        },
        
        _castFromNumber: function(value) {
            return "VALUE" + value;
        }
        
    });
    
});
