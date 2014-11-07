define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _type: "NumberRangeValidator",
        
        _min: undefined,
        
        _max: undefined,
        
        /**
         * Create NumberRangeValidator.
         * 
         * @param {Float} min - Minimum value.
         * @param {Float} max - Maximum value.
         * @param {Function} message - Function with a message string as return value.
         */
        constructor: function(min, max, message) {
            if (message) {
                this._messageCallback = message;
            }
            this._defaultMessage = "The number is out of the specified range! "
                                 + (min ? "Minimum value is " + min.toString() : "") + ". "
                                 + (max ? "Maximum value is " + max.toString() : "") + ". ";
            this._min = min;
            this._max = max;
        },
        
        isValid: function(value) {
            if (!value.isSet()) {
                return true;
            }
            return value.toString().match(/^-?\d*(\.\d+)?$/i)
                && (!this._min || this._min.lte(value))
                && (!this._max || this._max .gte(value));
        }
        
    });
});
