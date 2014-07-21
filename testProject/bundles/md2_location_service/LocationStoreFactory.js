define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/store/util/QueryResults",
    "esri/tasks/locator",
    "esri/geometry/Point"
], function(declare, lang, QueryResults, Locator, Point) {
    
    var LocationStore = declare([], {
        
        /** 
         * Defines the Accept header to use on HTTP requests
         */
        accepts: "application/javascript, application/json",
        
        /**
         * Additional headers to pass in all requests to the server. These can be overridden
         * by passing additional headers to calls to the store.
         */
        headers: {},
        
        /**
         * URL of the web service. Injected by property constructor or mixed in as option.
         */
        url: null,
        
        /**
         * The factory of the entity that is managed by this store. It is used to construct new instances of this
         * entity, and populate it with the values received from the backend. Furthermore, it
         * is provided to the content provider (e.g. to reset the content provider).
         */
        entityFactory: undefined,
        
        constructor: function(options) {
            declare.safeMixin(this, options);
        },
        
        _reverseGeoCode: function() {
            var locationHandler = this._locationHandler;
            var latitude = locationHandler.getLatitude();
            var longitude = locationHandler.getLongitude();
            
            var locator = new Locator(this.url);
            var promise = locator.locationToAddress(new Point(latitude, longitude), 500);
            
            return promise;
        },
        
        _storeAddressInLocationEntity: function(promise) {
            
            /*
             * Format of the address entity as returned by the ArcGIS server:
             * "address": {
             *    "Address": "6 Avenue Gustave Eiffel",
             *    "Neighborhood": "7e Arrondissement",
             *    "City": "Paris",
             *    "Subregion": "Paris",
             *    "Region": "Île-de-France",
             *    "Postal": "75007",
             *    "PostalExt": null,
             *    "CountryCode": "FRA",
             *    "Loc_name": "FRA.PointAddress"
             * }
             */
            promise = promise.then(lang.hitch(this, function(addressCandidate) {
                var locationEntity = this.entityFactory.create();
                
                var lat = addressCandidate.location.x;
                locationEntity.latitude = locationEntity.latitude.create(lat);
                
                var long = addressCandidate.location.y;
                locationEntity.longitude = locationEntity.longitude.create(long);
                
                var alt = null;
                locationEntity.altitude = locationEntity.altitude.create(alt);
                
                var city = addressCandidate.address.City;
                locationEntity.city = locationEntity.city.create(city);
                
                var street = addressCandidate.address.Address;
                locationEntity.street = locationEntity.street.create(street);
                
                var number = null;
                locationEntity.number = locationEntity.number.create(number);
                
                var postal = addressCandidate.address.Postal;
                locationEntity.postalCode = locationEntity.postalCode.create(postal);
                
                var countryCode = addressCandidate.address.CountryCode;
                locationEntity.country = locationEntity.country.create(countryCode);
                
                var province = addressCandidate.address.Region;
                locationEntity.province = locationEntity.province.create(province);
                
                return [locationEntity];
            }));
            
            return promise;
        },
        
        query: function(query, options) {
            if (query) {
                var msg = "[LocationStoreFactory] Store does not support querying. The passed query is ignored.";
                console && console.warn(msg);
            }
            var promise = this._reverseGeoCode();
            promise = this._storeAddressInLocationEntity(promise);
            return QueryResults(promise);
        },
        
        get: function(id) {
            throw new Error("Read-only store: Unsupported operation!")
        },
        
        put: function(object, options) {
            throw new Error("Read-only store: Unsupported operation!")
        },
        
        add: function(object, options) {
            throw new Error("Read-only store: Unsupported operation!")
        },
        
        remove: function(id) {
            throw new Error("Read-only store: Unsupported operation!")
        }
        
    });
    
    /**
     * Factory for the LocationStore
     */
    return declare([], {
        
        /**
         * Identifier to get the type of the store this factory creates.
         */
        type: "location",
        
        create: function(options) {
            options.url = options.url || this._properties.url;
            return new LocationStore(options);
        }
        
    });
});
