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
                    return new Boolean(platformValue);
                case "date":
                    return new Date(platformValue);
                case "time":
                    return new Time(platformValue);
                case "datetime":
                    return new DateTime(platformValue);
                case "float":
                    return new Float(platformValue);
                case "integer":
                    return new Integer(platformValue);
                case "string":
                    return new String(platformValue);
                default:
                    return TypeFactory.createEntity(datatype);
            }
        },
        
        createEntity: function(datatype) {
            var factory;
            array.some(TypeFactory.entityFactories, function(entityFactory) {
                if (entityFactory.datatype === datatype) {
                    factory = entityFactory;
                    return false;
                }
            }, this);
            
            if (factory) {
                return factory.create();
            } else {
                console && console.error("[TypeFactory] No Entity with datatype '" + datatype + "' found!");
            }
        }
        
    };
    
    return TypeFactory;
    
});
