define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/json", "ct/_lang", "./ContentProvider", "../datatypes/TypeFactory"
],

/**
 * Registry that manages all content providers. A reference to this registry can be passed to
 * all MD2 components that deal with component providers.
 */
function(declare, d_lang, json, ct_lang, ContentProvider, TypeFactory) {
    return declare([], {
        
        _contentProviders: null,
        
        _storeFactory: null,
        
        _entityDefinitions: null,
        
        /**
         * Keep a table of all stores, so that each store configuration is always stored only once.
         * As the key the store configuration is used. The values are a reference to the actual store.
         * Format: <hash>: <referenceToStore>
         */
        _stores: null,
        
        constructor: function(storeFactory, entityDefinitions) {
            this._contentProviders = {};
            this._stores = {};
            this._storeFactory = storeFactory;
            this._entityDefinitions = entityDefinitions;
        },
        
        getContentProvider: function(contentProviderName) {
            return this._contentProviders[contentProviderName];
        },
        
        /**
         * Supported options:
         *   type - ["remote"|"local"] Create a local or a remote data store (optional, default: remote).
         *   entity - Name of the entity for which the store should be created. (required)
         *   serviceUri - Overwrite the default URI of the backend web service used for the store (optional).
         *   filter - Configure filter for the content provider (optional).
         *   storeOptions - Further options for the remote store configuration (optional).
         * 
         * @param {string} contentProviderName - Name of the content provider to create.
         * @param {Object} options - Configuration of the content provider.
         */
        registerContentProvider: function(contentProviderName, options) {
            var config = {
                type: "remote"
            };
            
            d_lang.mixin(config, options);
            
            var filter = config.filter;
            delete config.filter;
            
            var isManyProvider = config.isManyProvider;
            
            var store = this._getOrCreateStore(config);
            var contentProvider = new ContentProvider(contentProviderName, store, isManyProvider, filter);
            this._contentProviders[contentProviderName] = contentProvider;
        },
        
        hasContentProvider: function(contentProviderName) {
            return this._contentProviders.hasOwnProperty(contentProviderName);
        },
        
        /**
         * Returns the store for the given entity if it exists. Otherwise, creates a new store
         * for that entity, stores it to the local _stores object and returns the newly created store.
         * 
         * @param {string} config - Object with the configuration of the store.
         * @returns {MD2Store} An MD2Store for the specified entity.
         */
        _getOrCreateStore: function(config) {
            
            var key = json.stringify(config);
            
            if(!this._stores[key]) {
                
                var entity = this._createMD2DatatypedEntity(this._entityDefinitions[config.entityName]);
                
                if(config.type === "remote") {
                    var remoteConfig = {
                        entityName: config.entityName,
                        entity: entity
                    };
                    if(config.serviceUri) remoteConfig.serviceUri = config.serviceUri;
                    this._stores[key] = this._storeFactory.newInstance(remoteConfig, config.options);
                }
                
                if(config.type === "local") {
                    // TODO
                }
                
            }
            
            return this._stores[key];
        },
        
        _createMD2DatatypedEntity: function(entityDefinition) {
            var md2Entity = {};
            ct_lang.forEachOwnProp(entityDefinition, function(value, name) {
                md2Entity[name] = TypeFactory.create(value.datatype, value.defaultValue);
            });
            return md2Entity;
        }
        
    });
});
