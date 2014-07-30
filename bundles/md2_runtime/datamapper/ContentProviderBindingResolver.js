define([
    "dojo/_base/declare", "./ContentProviderBinding"
], function(declare, ContentProviderBinding) {
    
    return declare([], {
        /**
         * Checks if binding type is "contentProvider" and gives the opts directly to the ContentProviderBinding.
         * 
         * @param type - Type of the content provider. Binding is only returned if type is "contentProvider".
         * @param opts - Object of options.
         * @return {ContentProviderBinding} The binding.
         */
        resolveBinding: function(type, opts) {
            if (type !== "contentProvider") {
                return undefined;
            }
            return new ContentProviderBinding(opts);
        }
    });
});
