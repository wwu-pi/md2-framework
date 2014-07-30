define([
    "dojo/_base/declare",
    "../_Action"
],
function(declare, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: undefined,
        
        _contentProvider: undefined,
        
        constructor: function(contentProvider) {
            this._actionSignature = "ContentProviderResetAction$$" + contentProvider;
            this._contentProvider = contentProvider;
        },
        
        execute: function() {
            this.$.contentProviderRegistry.getContentProvider(this._contentProvider).reset();
        }
        
    });
});
