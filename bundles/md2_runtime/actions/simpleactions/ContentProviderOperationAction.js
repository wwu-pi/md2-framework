define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "../_Action"
],
function(declare, lang, array, _Action) {
    
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
                throw new Error("[ContentProviderOperationAction] Unsupported data action '" + this._operation + "'!");
                return;
            }
            
            // register callback to be executed by the data event handler
            this.$.dataEventHandler.registerDataEvent(lang.hitch(this, function() {
                var contentProvider = this.$.contentProviderRegistry.getContentProvider(this._contentProvider);
                contentProvider && contentProvider[this._operation]();
            }));
        }
        
    });
});
