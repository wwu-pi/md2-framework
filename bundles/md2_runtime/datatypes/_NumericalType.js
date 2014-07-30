define([
    "dojo/_base/declare", "./_Type"
], function(declare, _Type) {
    
    return declare([_Type], {
        
        gt: function(value) {
            if (!value || !value.getPlatformValue) {
                value = this.create(value);
            }
            return this._precheck(value) && this._gt(value);
        },
        
        gte: function(value) {
            if (!value || !value.getPlatformValue) {
                value = this.create(value);
            }
            return this._precheck(value) && this._gte(value);
        },
        
        lt: function(value) {
            if (!value || !value.getPlatformValue) {
                value = this.create(value);
            }
            return this._precheck(value) && this._lt(value);
        },
        
        lte: function(value) {
            if (!value || !value.getPlatformValue) {
                value = this.create(value);
            }
            return this._precheck(value) && this._lte(value);
        },
        
        _precheck: function(value) {
            return !(this._platformValue === undefined || this._platformValue === null
                || value.getPlatformValue() === undefined || this._platformValue === null);
        },
        
        _gt: function(value) {
            // Override in concrete datatype in cases of none-default comparisons
            return this._platformValue > value.getPlatformValue();
        },
        
        _gte: function(value) {
            // Override in concrete datatype in cases of none-default comparisons
            return this._platformValue >= value.getPlatformValue();
        },
        
        _lt: function(value) {
            // Override in concrete datatype in cases of none-default comparisons
            return this._platformValue < value.getPlatformValue();
        },
        
        _lte: function(value) {
            // Override in concrete datatype in cases of none-default comparisons
            return this._platformValue <= value.getPlatformValue();
        }
        
    });
    
});
