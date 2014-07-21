define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "./_GlobalEvent"
],
function(declare, lang, topic, _GlobalEvent) {
    return declare([_GlobalEvent], {
        
        _setEvent: function() {
            var reference = topic.subscribe("md2/locationEvent/onLocationUpdate", lang.hitch(this, function() {
                this._onEvent();
            }));
            return reference;
        },
        
        _unsetEvent: function(eventHandler) {
            eventHandler.remove();
        }
        
    });
});
