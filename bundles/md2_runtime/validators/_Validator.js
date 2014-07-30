define([
    "dojo/_base/declare"
],
function(declare) {
    /**
     * Interface for validators.
     */
    return declare([], {
        
        _message: "",
        
        _type: "",
        
        isValid: function(value) {
            
        },
        
        getType: function() {
            return this._type;
        },
        
        getMessage: function() {
            return this._message;
        }
        
    });
});
