define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _type: "NotNullValidator",
        
        /**
         * Create NotNullValidator.
         * 
         * @param {Function} message - Function with a message string as return value.
         */
        constructor: function(message) {
            if (message) {
                this._messageCallback = message;
            }
            this._defaultMessage = "This value is required!";
        },
        
        isValid: function(value) {
            return value.isSet();
        }
        
    });
});
