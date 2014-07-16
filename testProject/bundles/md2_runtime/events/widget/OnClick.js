define([
    "dojo/_base/declare", "dojo/_base/lang", "./_WidgetEvent"
],
function(declare, lang, _WidgetEvent) {
    return declare([_WidgetEvent], {
        
        _setEvent: function(widget) {
            var reference = widget.on("click", lang.hitch(this, function() {
                this._onEvent(widget);
            }));
            return reference;
        },
        
        _unsetEvent: function(eventHandler) {
            eventHandler.remove();
        }
        
    });
});
