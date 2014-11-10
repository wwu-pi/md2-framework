define([
    "dojo/_base/declare"
],
function(declare) {
    
    return declare([], {
        
        register: function() {
            
            this.$.observe("startView$outerPanel$firstName", function() {
                if (this.$.get("startView$outerPanel$firstName") === "John" && this.$.get("startView$outerPanel$customerId") < 1000) {
                    this.$.fire("myEvent");
                }
            });
            
            this.$.observe("startView$outerPanel$firstName", function() {
                if (this.$.get("startView$outerPanel$lastName") === "Doe" && this.$.isValid("startView$outerPanel$customerId")) {
                    this.$.fire("myOtherEvent");
                }
            });
        }
        
    });
});
