define([
    "dojo/_base/declare", "ct/Hash"
],
function(declare, Hash) {
    return declare([], {
        
        /**
         * Hash
         */
        _widgets: undefined,
        
        constructor: function() {
            this._widgets = new Hash();
        },
        
        getWidget: function(id) {
            return this._widgets.get(id);
        },
        
        add: function(widget) {
            var id = widget.getId();
            if (id) {
                this._widgets.set(id, widget);
            }
        },
        
        remove: function(widget) {
            var id = widget.getId();
            if (this._widgets.contains(id)) {
                this._widgets.remove(id);
            }
        }
    });
});
