define([
    "dojo/_base/declare", "ct/Stateful"
], function(declare, Stateful) {
    /**
     * Stateful Binding syncs bettween Stateful data and dataform access.
     * -> Note it does not support index access. It is very plain and should help to auto bind uis to model changes.
     */
    return declare([], {
        stateful: null,
        constructor: function(opts) {
            var stateful = this.stateful = opts.data;
            var watchers = this.watchers = new Stateful();
            watchers._count = 0;
        },
        get: function(name, index) {
            // dot properties directly retrieved from stateful
            // index is ignored
            return this.stateful.get(name);
        },
        set: function(name, val, index) {
            // index is ignored!
            this.stateful.set(name, val);
        },
        watch: function(fieldname, cb) {
            var watchers = this.watchers;
            var handle = watchers.watch(fieldname, cb);
            ++watchers._count;
            if (watchers._count === 1) {
                watchers._handle = this.stateful.watch("*", function(name, old, val) {
                    watchers._firePropertyChange(name, old, val);
                });
            }
            return {
                unwatch: function() {
                    handle.unwatch();
                    --watchers._count;
                    if (!watchers._count) {
                        watchers._handle.unwatch();
                        watchers._handle = null;
                    }
                }
            };
        }
    });
});