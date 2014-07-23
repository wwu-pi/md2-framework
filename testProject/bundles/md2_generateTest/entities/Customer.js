define([
	"dojo/_base/declare",
	"dojo/date/stamp",
	"../../md2_runtime/entities/_Entity"
],
function(declare, stamp, _Entity) {
	
	var Customer = declare([_Entity], {
		
		_datatype: "Customer",
		
		attributeTypes: {
			customerID: "integer",
			firstName: "string",
			lastName: "string",
			residence: "string",
			expectedSales: "float",
			dateOfBirth: "date",
			ownsProperty: "boolean"
		},
		
		_initialize: function() {
			this._attributes = {
				customerID: this._typeFactory.create("integer", 1000),
				firstName: this._typeFactory.create("string", null),
				lastName: this._typeFactory.create("string", null),
				residence: this._typeFactory.create("string", null),
				expectedSales: this._typeFactory.create("float", 0.0),
				dateOfBirth: this._typeFactory.create("date", null),
				ownsProperty: this._typeFactory.create("boolean", false)
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
