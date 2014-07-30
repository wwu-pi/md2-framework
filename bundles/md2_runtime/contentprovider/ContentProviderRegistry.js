define([
    "dojo/_base/declare"
],

/**
 * Registry that manages all content providers. A reference to this registry can be passed to
 * all MD2 components that deal with component providers.
 */
function(declare) {
    return declare([], {
        
        _contentProviders: null,
        
        constructor: function() {
            this._contentProviders = {};
        },
        
        getContentProvider: function(contentProviderName) {
            return this._contentProviders[contentProviderName];
        },
        
        registerContentProvider: function(contentProvider) {
            this._contentProviders[contentProvider.getName()] = contentProvider;
        },
        
        hasContentProvider: function(contentProviderName) {
            return this._contentProviders.hasOwnProperty(contentProviderName);
        }
        
    });
});
