define([
    "dojo/_base/declare", "ct/_lang"
], function(declare, ct_lang) {
    
    return declare([], {
        
        _datatype: "undefined",
        
        attributeTypes: {
            // To be implemented in concrete class.
            // return {
            //   xxx: "yyy",
            //   ...
            // }
        },
        
        /**
         * Internal ID as set by the MD2 backend. Entities that are stored
         * automatically get an internal ID assigned.
         */
        _internalID: null,
        
        /**
         * Instance of the type factory that created this entity. Used to construct the default values.
         */
        _typeFactory: null,
        
        /**
         * Attributes of this entity. Object of the form:
         * {
         *   attr1Name: VALUE,
         *   attr2Name: VALUE
         *   ...
         * }
         */
        _attributes: null,
        
        constructor: function(typeFactory) {
            this._typeFactory = typeFactory;
            this._initialize();
        },
        
        get: function(attributeName) {
            return this._attributes[attributeName];
        },
        
        set: function(attributeName, value) {
            this._attributes[attributeName] = value;
        },
        
        getInternalID: function() {
            return this._internalID;
        },
        
        setInternalID: function(internalID) {
            this._internalID = internalID;
        },
        
        hasInternalID: function() {
            return !!this._internalID;
        },
        
        /**
         * Get type (name) of this entity.
         * @returns {String} Type identifier.
         */
        getType: function() {
            return this._datatype;
        },
        
        /**
         * Creates a new entity object of the same type. This utility method can
         * be useful, if a new entity object of the same type is required.
         * 
         * @returns {_Entity}
         */
        create: function() {
            return this._typeFactory.create(this._datatype);
        },
        
        clone: function() {
            var newEntity = this.create();
            ct_lang.forEachOwnProp(this._attributes, function(value, name) {
                newEntity._attributes[name] = value ? value.clone() : value;
            });
            return newEntity;
        },
        
        /**
         * @returns {String} String representation of this entity.
         */
        toString: function() {
            var attr = [];
            ct_lang.forEachOwnProp(this._attributes, function(value, name) {
                attr.push(name + ": " + value);
            });
            return "[" + attr.join(", ") + "]";
        },
        
        /**
         * @param {_Entity|_Type} value - Another _Entity or _Type to compare with.
         * @returns {boolean}
         */
        equals: function(value) {
            
            if (!value) {
                return false;
            }
            
            var isEntityEqual = true;
            ct_lang.forEachOwnProp(this._attributes, function(thisValue, name) {
                var isAttrEqual = !value[name] && value[name] === thisValue[name]
                                  || thisValue[name].equals(value[name]);
                isEntityEqual = isEntityEqual && isAttrEqual;
            });
            return isEntityEqual;
        },
        
        _initialize: function() {
            // To be implemented in concrete class.
            // Set all default values here.
            
            // example (with xxx := attributeName, yyy := datatype, zzz := valueObject):
            // 
            // this._attributes = {
            //   xxx: this._typeFactory.create("yyy", "zzz"),
            //   ...
            // }
        }
        
    });
    
});
