define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "./_WidgetEvent"
],
function(declare, lang, topic, _WidgetEvent) {
    return declare([_WidgetEvent], {
        
        _reference: null,
        
        _setEvent: function() {
            if(this._reference) {
                return;
            }
            this._reference = topic.subscribe("md2/widget/onChange", lang.hitch(this, function(widget) {
                this._onEvent(widget);
            }));
        }
        
    });
});
