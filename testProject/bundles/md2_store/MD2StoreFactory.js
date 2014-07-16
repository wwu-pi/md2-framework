define([
    "dojo/_base/declare", "./MD2Store"
], function(declare, MD2Store) {
    
    return declare([], {
        
        _defaultServiceUri: null,
        
        _WARNING_MSG1: "MD2StoreFactory: Target property in options object will be overwritten!",
        
        _WARNING_MSG2: "MD2StoreFactory: No serviceUri or table are passed to createInstance"
                        + "method. Target property has to be set manually in the created store!",
        
        /**
         * Create a new instance of the MD2 store. If a default service URI is set, it is used to create the service.
         * The default service URI can be overwritten by explicitly setting another service URI in the configuration object.
         * 
         * In case no configuration object has been passed to the function, the store has to be configured accordingly
         * in the aftermath (set target property).
         * 
         * @param {Object} configuration - Configuration object of the form {serviceUri: <string>, table: <string>},
         *                 with the service URI being optional if a defaultService is defined.
         * @param {Object} options - Overwrite default options of created store.
         * @returns {MD2Store}
         */
        newInstance: function(configuration, options) {
            
            configuration = configuration || {};
            options = options || {};
            
            // pass default service if not present in configuration object
            if(typeof configuration.serviceUri === "undefined" && this._defaultServiceUri) {
                configuration.serviceUri = this._defaultServiceUri;
            }
            
            // build target from serviceUri and entity name
            if (configuration.serviceUri && configuration.entityName) {
                configuration.serviceUri = configuration.serviceUri.replace(/\/+$/, "") + "/"; // ensure trailing slash
                options.url && window.console && console.warn(this._WARNING_MSG1);
                options.url = configuration.serviceUri + configuration.entityName;
            } else {
                window.console && console.warn(this._WARNING_MSG2);
            }
            
            options.entity = configuration.entity;
            
            return new MD2Store(options);
        },
        
        /**
         * Set a default service URI to be used when a new service is created.
         * 
         * The default service URI can be overwritten by explicitly setting another
         * service URI in the configuration object that is passed to the createInstance method.
         * 
         * @param {String} defaultServiceUri - Default service URI.
         */
        setDefaultServiceUri: function(defaultServiceUri) {
            this._defaultServiceUri = defaultServiceUri;
        }
        
    });
});
