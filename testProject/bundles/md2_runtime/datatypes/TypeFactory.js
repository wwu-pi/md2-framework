define([
    "dojo/_base/array",
    "./Boolean",
    "./Date",
    "./Time",
    "./DateTime",
    "./Float",
    "./Integer",
    "./String"
],
function(array, Boolean, Date, Time, DateTime, Float, Integer, String) {
    
    var TypeFactory = {
        
        entityFactories: null,
        
        create: function(datatype, platformValue) {
            switch (datatype) {
                case "boolean":
                    return new Boolean(platformValue, TypeFactory);
                case "date":
                    return new Date(platformValue, TypeFactory);
                case "time":
                    return new Time(platformValue, TypeFactory);
                case "datetime":
                    return new DateTime(platformValue, TypeFactory);
                case "float":
                    return new Float(platformValue, TypeFactory);
                case "integer":
                    return new Integer(platformValue, TypeFactory);
                case "string":
                    return new String(platformValue, TypeFactory);
                default:
                    return TypeFactory.createEntity(datatype);
            }
        },
        
        createEntity: function(datatype) {
            return TypeFactory.getEntityFactory(datatype).create();
        },
        
        getEntityFactory: function(datatype) {
            var factory;
            array.some(TypeFactory.entityFactories, function(entityFactory) {
                if (entityFactory.datatype === datatype) {
                    factory = entityFactory;
                    return false;
                }
            }, this);
            
            if (factory) {
                return factory;
            } else {
                console && console.error("[TypeFactory] No Entity with datatype '" + datatype + "' found!");
            }
        }
        
    };
    
    return TypeFactory;
    
});
