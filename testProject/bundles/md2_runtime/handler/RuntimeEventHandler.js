define([
    "dojo/_base/declare", "dojo/topic"
],
function(declare, topic) {
    
    return declare([], {
        
        _onConnectionStatusChange: function(status) {
            if (status === "offline") {
                topic.publish("md2/connectionEvent/onConnectionLost");
            }
            
            if (status === "online") {
                topic.publish("md2/connectionEvent/onConnectionRegained");
            }
        },
        
        _onLocationUpdate: function(event) {
            var lat = event.getProperty("latitude");
            var long = event.getProperty("longitude");
            if (lat && long) {
                topic.publish("md2/locationEvent/onLocationUpdate", lat, long);
            }
        },
        
        _onWindowResize: function() {
            topic.publish("md2/window/onResize");
        }
        
    });
});
