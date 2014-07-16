define([
    "dojo/_base/declare",
    "../_Action"
],
function(declare, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: undefined,
        
        _view: undefined,
        
        constructor: function(view) {
            this._actionSignature = "GotoViewAction$$" + view;
            this._view = view;
        },
        
        execute: function() {
            this.$.viewManager.goto(this._view);
        }
        
    });
});
