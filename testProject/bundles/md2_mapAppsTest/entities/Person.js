define([
    "dojo/_base/declare", "../../md2_runtime/entities/_Entity"
], function(declare, _Entity) {
    
    var Person = declare([_Entity], {
        
        _datatype: "Person",
        
        _initialize: function() {
            this._attributes = {
                firstName: this._typeFactory.create("string", "John"),
                lastName: this._typeFactory.create("string", "Doe"),
                customerID: this._typeFactory.create("integer", 242454)
            };
        }
        
    });
    
    /**
     * Factory
     */
    return declare([], {
        
        datatype: "Person",
        
        create: function() {
            return new Person();
        }
        
    });
    
});
