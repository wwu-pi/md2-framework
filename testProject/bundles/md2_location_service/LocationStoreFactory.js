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
            var locationHandler = this.locationHandler;
            var longitude = locationHandler.getLongitude();
            var latitude = locationHandler.getLatitude();
            
            // ArcGIS World Geocoding Service API:
            // https://developers.arcgis.com/rest/geocode/api-reference/overview-world-geocoding-service.htm
            var locator = new Locator(this.url);
            var promise = locator.locationToAddress(new Point(longitude, latitude), 1000);
            
            return promise;
        },
        
        _storeAddressInLocationEntity: function(promise) {
            
            /*
             * Format of the address entity as returned by the ArcGIS server:
             * {
             *   "address": {
             *     "Address": "1098 S Rocky Ford Trail Rd",
             *     "Neighborhood": null,
             *     "City": "Circleville",
             *     "Subregion": null,
             *     "Region": "Utah",
             *     "Postal": "84723",
             *     "PostalExt": null,
             *     "CountryCode": "USA",
             *     "Loc_name": "USA.StreetAddress"
             *   },
             *   "location": {
             *     "x": -112.21653860760983,
             *     "y": 38.150483035342795,
             *     "spatialReference": {
             *       "wkid": 4326,
             *       "latestWkid": 4326
             *     }
             *   }
             * }
             */
            promise = promise.then(lang.hitch(this, function(addressCandidate) {
                
                var locationEntity = this.entityFactory.create();
                
                var lat = addressCandidate.location.x;
                locationEntity.set("latitude", locationEntity.get("latitude").create(lat));
                
                var long = addressCandidate.location.y;
                locationEntity.set("longitude", locationEntity.get("longitude").create(long));
                
                var alt = null;
                locationEntity.set("altitude", locationEntity.get("altitude").create(alt));
                
                var city = addressCandidate.address.City;
                locationEntity.set("city", locationEntity.get("city").create(city));
                
                var street = addressCandidate.address.Address;
                locationEntity.set("street", locationEntity.get("street").create(street));
                
                var number = null;
                locationEntity.set("number", locationEntity.get("number").create(number));
                
                var postal = addressCandidate.address.Postal;
                locationEntity.set("postalCode", locationEntity.get("postalCode").create(postal));
                
                var countryCode = addressCandidate.address.CountryCode;
                locationEntity.set("country", locationEntity.get("country").create(countryCode));
                
                var province = addressCandidate.address.Region;
                locationEntity.set("province", locationEntity.get("province").create(province));
                
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
            options.locationHandler = this._locationHandler;
            return new LocationStore(options);
        }
        
    });
});
