define([
    "dojo/_base/declare", "dojo/_base/lang"
], function(declare, lang) {
    
    /**
     * A set that can handle arbitrary objects that implement a toString method to identify them.
     */
    var Set = declare([], {
        
        _data: {},
        
        /**
         * Constructor: Create a new set.
         * The set can be initialized with a list of values, sets or an array of values.
         * 
         * Valid constructors are:
         * new Set()
         * new Set(1,2, ..., n)
         * new Set(["1", "2", "3"])
         * new Set(otherSet1, otherSet2, ...)
         */
        constructor: function() {
            this.add.apply(this, arguments);
        },
        
        /**
         * Add values to the set.
         * 
         * Examples:
         * set.add(1,2, ..., n)
         * set.add(["1", "2", "3"])
         * set.add(otherSet1, otherSet2, ...)
         */
        add: function() {
            var key;
            for (var i = 0; i < arguments.length; i++) {
                key = arguments[i];
                if (lang.isArray(key)) {
                    for (var j = 0; j < key.length; j++) {
                        this._data[key[j]] = key[j];
                    }
                } else if (key instanceof Set) {
                    key.forEach(function(val, key) {
                        this._data[key] = val;
                    }, this);
                } else {
                    this._data[key] = key;
                }
            }
        },
        
        /**
         * Remove values from the set.
         * 
         * Examples:
         * set.remove(1,2, ..., n)
         * set.remove(["1", "2", "3"])
         */
        remove: function() {
            var item;
            for (var j = 0; j < arguments.length; j++) {
                item = arguments[j];
                if (lang.isArray(item)) {
                    for (var i = 0; i < item.length; i++) {
                        this._removeItem(item[i]);
                    }
                } else {
                    this._removeItem(item);
                }
            }
        },
        
        /**
         * Check whether the set contains the given value.
         * @param {Object} value
         * @returns {Boolean}
         */
        contains: function(value) {
            return this._data.hasOwnProperty(value);
        },
        
        /**
         * Check whether the set is empty.
         * @returns {Boolean}
         */
        isEmpty: function() {
            for (var key in this._data) {
                if (this.contains(key)) {
                    return false;
                }
            }
            return true;
        },
        
        /**
         * Returns an array that contains all values of this set.
         * @returns {Array}
         */
        toArray: function() {
            var results = [];
            this.forEach(function(data) {
                results.push(data);
            });
            return results;
        },
        
        /**
         * Clears set.
         */
        clear: function() {
            this._data = {}; 
        },
        
        /**
         * Iterate over all elements in the Set and apply callback method to the given value.
         * If the callback returns false, the iteration is stopped.
         * 
         * @param {Function} fn - Callback function function(value) {...}.
         * @param {Object} scope - (optional) Scope for the callback function.
         * @returns {Boolean} Returns false if the iteration was stopped, otherwise true.
         *                    Can for example be used to search objects with certain properties in the set.
         */
        forEach: function(fn, scope) {
            for (var key in this._data) {
                if (this.contains(key)) {
                    scope = scope || this;
                    if (fn.call(scope, this._data[key], key) === false) {
                        return false;
                    }
                }
            }
            return true;
        },
        
        _removeItem: function(key) {
            delete this._data[key];
        }
        
    });
    
    return Set;
});
