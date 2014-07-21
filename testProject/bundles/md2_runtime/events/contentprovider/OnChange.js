define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "./_ContentProviderEvent"
],
function(declare, lang, topic, _ContentProviderEvent) {
    return declare([_ContentProviderEvent], {
        
        _reference: null,
        
        _setEvent: function(contentProvider, attribute) {
            if(!this._reference) {
                var topicName = "md2/contentProvider/onChange/" + this._appId;
                this._reference = topic.subscribe(topicName, lang.hitch(this, function(contentProvider, attribute) {
                    this._onEvent(contentProvider, attribute);
                }));
            }
            var eventHandler = contentProvider.registerObservedOnChange(attribute);
            return eventHandler;
        },
        
        _unsetEvent: function(eventHandler) {
            eventHandler.unregister();
        }
        
    });
});
