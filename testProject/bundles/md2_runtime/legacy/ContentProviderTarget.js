define([
    "dojo/_base/declare"
], function(declare) {
    
    return declare([], {
        _contentProvider: null,
        
        _attribute: null,
        
        constructor: function(contentProvider, attribute) {
            this._contentProvider = contentProvider;
            this._attribute = attribute;
        },
        
        getContentProvider: function() {
            return this._contentProvider;
        },
        
        getAttribute: function() {
            return this._attribute;
        },
        
        toString: function() {
            return this._contentProvider.getName() + "$" + this._attribute;
        }
    });
});
