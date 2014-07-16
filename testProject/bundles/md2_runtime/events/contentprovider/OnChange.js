define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "./_ContentProviderEvent"
],
function(declare, lang, topic, _ContentProviderEvent) {
    return declare([_ContentProviderEvent], {
        
        _reference: null,
        
        _setEvent: function() {
            if(this._reference) {
                return;
            }
            this._reference = topic.subscribe("md2/contentProvider/onChange", lang.hitch(this, function(contentProvider, attribute) {
                this._onEvent(contentProvider, attribute);
            }));
        }
        
    });
});
