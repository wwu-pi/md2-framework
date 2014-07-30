define([
    "dojo/_base/declare", "./_Type"
], function(declare, _Type) {
    
    return declare([_Type], {
        
        _datatype: "string",
        
        toString: function() {
            return this._platformValue;
        },
        
        isSet: function() {
            return !!this._platformValue;
        },
        
        _castFromNumber: function(value) {
            return value.toString();
        },
        
        _castFromBoolean: function(value) {
            return value.toString();
        }
        
    });
    
});
