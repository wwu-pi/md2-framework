define([
    "dojo/_base/declare", "./_NumericalType"
], function(declare, _NumericalType) {
    
    return declare([_NumericalType], {
        
        _datatype: "integer",
        
        toString: function() {
            return this._platformValue ? this._platformValue.toString() : "0";
        },
        
        isSet: function() {
            return this._platformValue || this._platformValue === 0;
        },
        
        /**
         * Float values are automatically casted to integers.
         */
        _castFromNumber: function(value) {
            return this._toInt(value);
        },
        
        _castFromString: function(value) {
            return parseInt(value);
        },
        
        _toInt: function(value) {
            return value - value % 1;
        }
        
    });
    
});
