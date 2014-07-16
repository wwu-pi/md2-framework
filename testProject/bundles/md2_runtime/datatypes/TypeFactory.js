define([
    "./Boolean",
    "./Date",
    "./Time",
    "./DateTime",
    "./Float",
    "./Integer",
    "./String"
],
function(Boolean, Date, Time, DateTime, Float, Integer, String) {
    
    var TypeFactory = {
        
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
                default:
                    return new String(platformValue);
            }
        }
        
    };
    
    return TypeFactory;
    
});
