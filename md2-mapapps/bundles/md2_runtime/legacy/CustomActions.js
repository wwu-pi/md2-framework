define([
    "dojo/_base/declare"
],
function(declare) {
    
    return declare([], {
        
        startAction: function() {
            this.$.mapAction("startView$outerPanel$firstName", "customerProvider", "firstName");
            this.$.mapAction("startView$outerPanel$lastName", "customerProvider", "lastName");
            this.$.mapAction("startView$outerPanel$customerId", "customerProvider", "customerId");
            this.$.mapAction("startView$outerPanel$dateOfBirth", "customerProvider", "dateOfBirth");
            
            this.$.unmapAction("startView$outerPanel$customerId", "customerProvider", "customerId");
            this.$.mapAction("startView$outerPanel$lastName", "customerProvider", "firstName");
            
            this.$.mapAction("startView$outerPanel$juhu", "customerProvider", "firstName");
            
            //this.$.dataAction("customerProvider", "load");
            
            this.$.bindEventAction("onConnectionLost", null, "myConnectionIsGone", ["Oh no..."]);
        },
        
        myConnectionIsGone: function(text) {
            alert(text);
        }
        
    });
});
