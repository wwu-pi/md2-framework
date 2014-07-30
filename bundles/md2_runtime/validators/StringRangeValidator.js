define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _message: "",
        
        _type: "StringRangeValidator",
        
        _min: undefined,
        
        _max: undefined,
        
        /**
         * Create StringRangeValidator.
         * 
         * @param {integer} minLength - Minimum string length.
         * @param {integer} maxLength - Maximum string length.
         * @param {string} message
         */
        constructor: function(minLength, maxLength, message) {
            if (message) {
                this._message = message;
            } else {
                this._message = "The string length is out of the specified range! "
                                + (minLength ? "Minimum length is " + minLength : "") + ". "
                                + (maxLength ? "Maximum length is " + maxLength : "") + ". ";
            }
            this._min = minLength;
            this._max = maxLength;
        },
        
        isValid: function(value) {
            if (!value.isSet()) {
                return true;
            }
            return (!this._min || this._min <= value.getPlatformValue().length)
                && (!this._max || this._max >= value.getPlatformValue().length);
        }
        
    });
});
