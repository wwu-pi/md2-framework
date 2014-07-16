define([
    "dojo/_base/declare", "./_Type"
], function(declare, _Type) {
    
    return declare([_Type], {
        
        _datatype: "boolean",
        
        toString: function() {
            return this._platformValue.toString();
        },
        
        isSet: function() {
            return this._platformValue === true || this._platformValue === false;
        },
        
        _castFromString: function(value) {
            return !!value;
        },
        
        _castFromNumber: function(value) {
            return !!value;
        }
        
    });
    
});
