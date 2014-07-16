define([
    "dojo/_base/declare", "dojo/_base/lang", "./ObjectBinding", "./StatefulBinding"
], function(declare, d_lang, ObjectBinding, StatefulBinding) {
    var isFunction = d_lang.isFunction;
    var isStateful = function(obj) {
        return obj
                && isFunction(obj.get)
                && isFunction(obj.set)
                && isFunction(obj.watch);
    };
    return declare([], {
        /**
         * checks if binding type is "object" and gives the opts directly to the ObjectBinding.
         * @return {dataform.ObjectBinding} the binding
         */
        resolveBinding: function(type, opts) {
            if (type !== "object") {
                return undefined;
            }
            var data = opts.data;
            if (isStateful(data)) {
                return new StatefulBinding(opts);
            }
            return new ObjectBinding(opts);
        }
    });
});