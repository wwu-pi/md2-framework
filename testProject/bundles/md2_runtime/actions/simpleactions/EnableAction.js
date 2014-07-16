define([
    "dojo/_base/declare",
    "../_Action"
],
function(declare, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: undefined,
        
        _widget: undefined,
        
        constructor: function(widget) {
            this._actionSignature = "EnableAction$$" + widget;
            this._widget = widget;
        },
        
        execute: function() {
            this.$.widgetRegistry.getWidget(this._widget).setDisabled(false);
        }
        
    });
});
