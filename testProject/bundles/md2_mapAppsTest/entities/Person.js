define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var Person = declare([_Entity], {
		
		_datatype: "Person",
		
		attributeTypes: {
			firstName: "string",
			lastName: "string",
			email: "string"
		},
		
		_initialize: function() {
			this._attributes = {
				firstName: this._typeFactory.create("string", null),
				lastName: this._typeFactory.create("string", null),
				email: this._typeFactory.create("string", null)
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "Person",
		
		create: function() {
			return new Person();
		}
		
	});
});
