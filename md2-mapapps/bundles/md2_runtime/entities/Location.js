define([
    "dojo/_base/declare",
    "./_Entity"
],
function(declare, _Entity) {
    
    var Location = declare([_Entity], {
        
        _datatype: "Location",
        
        attributeTypes: {
            latitude: "string",
            longitude: "string",
            altitude: "string",
            city: "string",
            street: "string",
            number: "string",
            postalCode: "string",
            country: "string",
            province: "string"
        },
        
        _initialize: function() {
            this._attributes = {
                latitude: this._typeFactory.create("string", null),
                longitude: this._typeFactory.create("string", null),
                altitude: this._typeFactory.create("string", null),
                city: this._typeFactory.create("string", null),
                street: this._typeFactory.create("string", null),
                number: this._typeFactory.create("string", null),
                postalCode: this._typeFactory.create("string", null),
                country: this._typeFactory.create("string", null),
                province: this._typeFactory.create("string", null)
            };
        }
        
    });
    
    /**
     * Entity Factory
     */
    return declare([], {

        datatype: "Location",

        create: function() {
            return new Location(this.typeFactory);
        }

    });
});
