define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "../_Action"
],
function(declare, array, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: undefined,
        
        _contentProvider: undefined,
        
        _operation: undefined,
        
        constructor: function(contentProvider, operation) {
            this._actionSignature = "ContentProviderOperationAction$$" + contentProvider + "$" + operation;
            this._contentProvider = contentProvider;
            this._operation = operation;
        },
        
        execute: function() {
            if(array.indexOf(["load", "save", "remove"], this._operation) < 0) {
                console && console.error("ContentProviderOperationAction: Unsupported data action '" + this._operation + "'!");
                return;
            }
            this.$.dataEventHandler.registerDataEvent();
            var contentProvider = this.$.contentProviderRegistry.getContentProvider(this._contentProvider);
            contentProvider && contentProvider[this._operation]();
        }
        
    });
});
