define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _type: "DateRangeValidator",
        
        _min: undefined,
        
        _max: undefined,
        
        /**
         * Create DateRangeValidator.
         * 
         * @param {Date} min - ISO date format yyyy-MM-dd
         * @param {Date} max - ISO date format yyyy-MM-dd
         * @param {Function} message - Function with a message string as return value.
         */
        constructor: function(min, max, message) {
            if (message) {
                this._messageCallback = message;
            }
            this._defaultMessage = "The date is out of the specified range! "
                                 + (min ? "Not before " + min.toString() : "") + ". "
                                 + (max ? "Not after " + max.toString() : "") + ". ";
            this._min = min;
            this._max = max;
        },
        
        isValid: function(value) {
            if (!value.isSet()) {
                return true;
            }
            
            return (!this._min || this._min.lte(value))
                && (!this._max || this._max.gte(value));
        }
        
    });
});
