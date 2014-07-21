define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var Customer = declare([_Entity], {
		
		_datatype: "Customer",
		
		attributeTypes: {
			id: "integer",
			firstName: "string",
			lastName: "string"
		},
		
		_initialize: function() {
			this._attributes = {
				id: this._typeFactory.create("integer", null),
				firstName: this._typeFactory.create("string", null),
				lastName: this._typeFactory.create("string", null)
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "Customer",
		
		create: function() {
			return new Customer(this.typeFactory);
		}
		
	});
});
