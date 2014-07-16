define([
    "dojo/_base/declare", "dojo/_base/lang", "ct/Stateful"
], function(declare, d_lang, Stateful) {

    var splitField = function(fieldPath) {
        var parentPath = fieldPath.replace(/\.[^.]+$/, "");
        var fn = fieldPath.replace(parentPath + ".", "");
        if (parentPath === fn) {
            parentPath = "";
        }
        return {
            scope: parentPath,
            name: fn
        };
    };
    var u = undefined;

    return declare([], {
        data: null,
        constructor: function(opts) {
            this.data = opts.data || {};
            this.watchers = new Stateful();
        },
        get: function(name, index) {
            var n = splitField(name);
            name = n.name;
            var target = this._getTarget(n.scope);
            if (name) {
                target = target[name];
            }
            if (index !== u) {
                target = target[index];
            }
            return target;
        },
        set: function(name, val, index) {
            var old = this.get(name, index);
            if (old === val) {
                return;
            }
            var n = splitField(name);
            var subname = n.name;
            var target = this._getTarget(n.scope);
            if (index !== u) {
                if (subname) {
                    target = target[subname];
                }
                target[index] = val;
            } else {
                target[subname] = val;
            }
            this.watchers._firePropertyChange(name, old, val);
        },
        watch: function(fieldname, cb) {
            return this.watchers.watch(fieldname, cb);
        },
        _getTarget: function(n) {
            return n ? d_lang.getObject(n, false, this.data) : this.data;
        }
    });
});