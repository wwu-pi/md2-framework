define([
    "dojo/_base/declare", "ct/Hash", "./LocalStore"
], function(declare, Hash, LocalStore) {
    
    return declare([], {
        
        /**
         * Identifier to get the type of the store this factory creates.
         */
        type: "local",
        
        /**
         * Remember all created store instances. If a store for the same service uri and
         * entity type is request a second time, the existing instance is returned.
         */
        _stores: null,
        
        constructor: function() {
            this._stores = new Hash();
        },
        
        /**
         * Create a new instance of the local store.
         * 
         * @param {_EntityFactory} entityFactory - Entity factory that creates an
         *        entity that is handled by the created store.
         * @returns {LocalStore}
         */
        create: function(entityFactory) {
            
            var options = {
                entityFactory: entityFactory
            };
            
            // Look-up store in hash
            var storeId = entityFactory.datatype;
            if (this._stores.contains(storeId)) {
                return this._stores.get(storeId);
            } else {
                var store = new LocalStore(options);
                this._stores.set(storeId, store);
                return store;
            }
        }
        
    });
});
