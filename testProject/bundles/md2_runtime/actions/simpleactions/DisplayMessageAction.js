define([
    "dojo/_base/declare",
    "../_Action"
],
function(declare, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: undefined,
        
        _callback: undefined,
        
        constructor: function(signature, messageBuilder) {
            this._actionSignature = "DisplayMessageAction$$" + signature;
            this._callback = messageBuilder;
        },
        
        execute: function() {
            if (!this._callback) {
                return;
            }
            var message = this._callback.call(this);
            this.$.notificationService.info({
                message: message
            });
        }
        
    });
});
