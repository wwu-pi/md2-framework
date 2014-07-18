define([
    "dojo/_base/declare", "dojo/_base/lang"
], function(declare, lang) {
    
    return declare([], {
        
        _platformValue: undefined,
        
        _datatype: "undefined",
        
        _creatingFactory: null,
        
        constructor: function(value, creator) {
            this._creatingFactory = creator;
            this._platformValue = this._castChain(value);
        },
        
        getPlatformValue: function() {
            return this._platformValue;
        },
        
        getType: function() {
            return this._datatype;
        },
        
        /**
         * Creates a new datatype object with a new platform value, but the same
         * datatype. This utility method can be useful, if a new MD2 datatype object
         * of the same type is required. There exists no setPlatformValue() method
         * on purpose as that might lead to subtle bugs (e.g. allows to set a new
         * platform value without calling the actual setter of a target class etc.).
         * 
         * @param {type} value
         * @returns {_Type}
         */
        create: function(value) {
            var newInstance = this._creatingFactory.create(this._datatype, value);
            return newInstance;
        },
        
        clone: function() {
            return this.create(this._platformValue);
        },
        
        toString: function() {
            // To be implemented in concrete datatype
        },
        
        isSet: function() {
            // To be implemented in concrete datatype
        },
        
        equals: function(value) {
            if (!value || !value.getPlatformValue || value.getType() !== this.getType()) {
                value = this.create(value);
            }
            if (!this._platformValue || !value.getPlatformValue()) {
                return this._platformValue === value.getPlatformValue();
            }
            return this._equals(value);
        },
        
        _equals: function(value) {
            // Override in concrete datatype in cases of none-default comparisons
            return !!value && this._platformValue === value.getPlatformValue();
        },
        
        _castFromString: function(value) {
            // Override in concrete datatype if cast should be supported
            return value;
        },
        
        _castFromNumber: function(value) {
            // Override in concrete datatype if cast should be supported
            return value;
        },
        
        _castFromBoolean: function(value) {
            // Override in concrete datatype if cast should be supported
            return value;
        },
        
        /**
         * @param {type} value Input value.
         * @returns {type} Platform value casted to the correct type.
         */
        _castChain: function(value) {
            if (value && value.getPlatformValue) {
                value = value.getPlatformValue();
            }
            
            // now it is a JS type
            if (lang.isString(value)) {
                value = this._castFromString(value);
            } else if (typeof value === "number") {
                value = this._castFromNumber(value);
            } else if (typeof value === "boolean") {
                value = this._castFromBoolean(value);
            }
            
            return value;
        }
        
    });
    
});
