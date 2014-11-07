define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _type: "RegExValidator",
        
        _regExp: undefined,
        
        /**
         * Create RegExValidator that can be applied to fields with arbitrary datatypes.
         * The regex pattern is checked against the string representation of the given value.
         * 
         * @param {string} pattern - Regex pattern.
         * @param {Function} message - Function with a message string as return value.
         */
        constructor: function(pattern, message) {
            if (message) {
                this._messageCallback = message;
            }
            this._defaultMessage = "The input format is invalid!";
            this._regExp = new RegExp("^" + pattern + "$");
        },
        
        isValid: function(value) {
            return !value.isSet() || value.toString().match(this._regExp);
        }
        
    });
});
