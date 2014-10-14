define([
    "dojo/_base/declare", "./_NumericalType"
], function(declare, _NumericalType) {
    
    return declare([_NumericalType], {
        
        _datatype: "float",
        
        toString: function() {
            var str = this._platformValue ? this._platformValue.toString() : "0";
            if (str && !str.match(/\./)) {
                str += ".0";
            }
            return str;
        },
        
        isSet: function() {
            return this._platformValue || this._platformValue === 0;
        },
        
        _castFromString: function(value) {
            return parseFloat(value);
        }
        
    });
    
});
