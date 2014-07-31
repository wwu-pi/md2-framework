define([
    "dojo/_base/declare"
],
function(declare) {
    /**
     * Interface for validators.
     */
    return declare([], {
        
        _messageCallback: null,
        
        _defaultMessage: "",
        
        _type: "",
        
        isValid: function(value) {
            
        },
        
        getType: function() {
            return this._type;
        },
        
        getMessage: function() {
            if (this._messageCallback) {
                return this._messageCallback();
            } else {
                return this._defaultMessage;
            }
        }
        
    });
});
