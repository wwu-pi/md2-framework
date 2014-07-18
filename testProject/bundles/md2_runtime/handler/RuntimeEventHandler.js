define([
    "dojo/_base/declare", "dojo/topic"
],
function(declare, topic) {
    
    return declare([], {
        
        _onConnectionStatusChange: function(status) {
            if(status === "offline") {
                topic.publish("md2/connectionEvent/onConnectionLost");
            }
            
            if(status === "online") {
                topic.publish("md2/connectionEvent/onConnectionRegained");
            }
        }
        
    });
});
