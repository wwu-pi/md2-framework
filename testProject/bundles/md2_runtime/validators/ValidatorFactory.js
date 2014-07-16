define([
    "dojo/_base/declare",
    "./DateRangeValidator",
    "./DateTimeRangeValidator",
    "./TimeRangeValidator",
    "./NumberRangeValidator",
    "./StringRangeValidator",
    "./NotNullValidator",
    "./RegExValidator",
    "./RemoteValidator"
], function(
    declare,
    DateRangeValidator,
    DateTimeRangeValidator,
    TimeRangeValidator,
    NumberRangeValidator,
    StringRangeValidator,
    NotNullValidator,
    RegExValidator,
    RemoteValidator
) {
    
    return declare([], {
        
        getDateRangeValidator: function(min, max, message) {
            return new DateRangeValidator(min, max, message);
        },
        
        getDateTimeRangeValidator: function(min, max, message) {
            return new DateTimeRangeValidator(min, max, message);
        },
        
        getTimeRangeValidator: function(min, max, message) {
            return new TimeRangeValidator(min, max, message);
        },
        
        getNumberRangeValidator: function(min, max, message) {
            return new NumberRangeValidator(min, max, message);
        },
        
        getStringRangeValidator: function(min, max, message) {
            return new StringRangeValidator(min, max, message);
        },
        
        getNotNullValidator: function(message) {
            return new NotNullValidator(message);
        },
        
        getRegExValidator: function(pattern, message) {
            return new RegExValidator(pattern, message);
        },
        
        getRemoteValidator: function() {
            // TODO
        }
        
    });
});
