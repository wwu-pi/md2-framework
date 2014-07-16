define([
    "dojo/_base/declare", "./_Validator"
],
function(declare, _Validator) {
    
    return declare([_Validator], {
        
        _message: "",
        
        _type: "NotNullValidator",
        
        /**
         * Create NotNullValidator.
         * 
         * @param {string} message
         */
        constructor: function(message) {
            if (message) {
                this._message = message;
            } else {
                this._message = "This value is required!";
            }
        },
        
        isValid: function(value) {
            return value.isSet();
        }
        
    });
});
