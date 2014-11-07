define([
    "dojo/_base/declare", "./_Type"
], function(declare, _Type) {
    
    return declare([_Type], {
        
        _datatype: "string",
        
        toString: function() {
            return this._platformValue ? this._platformValue : "";
        },
        
        isSet: function() {
            return !!this._platformValue;
        },
        
        _castChain: function(value) {
            return value ? value.toString() : value;
        }
        
    });
    
});
