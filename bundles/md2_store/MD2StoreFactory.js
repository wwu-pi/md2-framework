define([
    "dojo/_base/declare", "ct/Hash", "./MD2Store"
], function(declare, Hash, MD2Store) {
    
    return declare([], {
        
        /**
         * Identifier to get the type of the store this factory creates.
         */
        type: "remote",
        
        /**
         * Remember all created store instances. If a store for the same service uri and
         * entity type is request a second time, the existing instance is returned.
         */
        _stores: null,
        
        constructor: function() {
            this._stores = new Hash();
        },
        
        /**
         * Create a new instance of the MD2 store. The URI of the store is inferred from
         * the serviceUri and the datatype of the passed entity factory.
         * 
         * @param {string} serviceUri - URI of the MD2 backend service.
         * @param {_EntityFactory} entityFactory - Entity factory that creates an
         *        entity that is handled by the created store.
         * @returns {MD2Store}
         */
        create: function(serviceUri, entityFactory) {
            
            if (!serviceUri || !entityFactory) {
                throw new Error("[MD2StoreFactory] The properties 'serviceUri' or 'entityFactory' are missing "
                        + "in the configuration object of method #create!");
            }
            
            var options = {
                url: this._formatUri(serviceUri, entityFactory.datatype),
                entityFactory: entityFactory
            };
            
            // Look-up store in hash
            if (this._stores.contains(options.url)) {
                return this._stores.get(options.url);
            } else {
                var store = new MD2Store(options);
                this._stores.set(options.url, store);
                return store;
            }
        },
        
        /**
         * Build target uri from serviceUri and entity name.
         */
        _formatUri: function(serviceUri, entityName) {
            // ensure trailing slash
            serviceUri = serviceUri.replace(/\/+$/, "") + "/";
            entityName = entityName.charAt(0).toLowerCase() + entityName.slice(1);
            return serviceUri + entityName;
        }
        
    });
});
