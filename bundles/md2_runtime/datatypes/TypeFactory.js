define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "./Boolean",
    "./Date",
    "./Time",
    "./DateTime",
    "./Float",
    "./Integer",
    "./String",
    "../entities/Location"
],
function(declare, array, Boolean, Date, Time, DateTime, Float, Integer, String, Location) {
    
    return declare([], {
        
        _entityFactories: null,
        
        constructor: function(entityFactories) {
            this._entityFactories = entityFactories;
            
            // configure all entity factories
            array.forEach(entityFactories, function(entityFactory) {
                entityFactory.typeFactory = this;
            }, this);
        },
        
        create: function(datatype, platformValue) {
            switch (datatype) {
                case "boolean":
                    return new Boolean(platformValue, this);
                case "date":
                    return new Date(platformValue, this);
                case "time":
                    return new Time(platformValue, this);
                case "datetime":
                    return new DateTime(platformValue, this);
                case "float":
                    return new Float(platformValue, this);
                case "integer":
                    return new Integer(platformValue, this);
                case "string":
                    return new String(platformValue, this);
                default:
                    return this.createEntity(datatype, platformValue);
            }
        },
        
        createEntity: function(datatype, platformValue) {
            return this.getEntityFactory(datatype).create(platformValue);
        },
        
        getEntityFactory: function(datatype) {
            
            if (datatype === "Location") {
                var locationFactory = new Location();
                locationFactory.typeFactory = this;
                return locationFactory;
            }
            
            // otherwise
            var factory;
            array.some(this._entityFactories, function(entityFactory) {
                if (entityFactory.datatype === datatype) {
                    factory = entityFactory;
                    return false;
                }
            }, this);
            
            if (factory) {
                return factory;
            } else {
                throw new Error("[TypeFactory] No Entity with datatype '" + datatype + "' found!");
            }
        }
        
    });
    
});
