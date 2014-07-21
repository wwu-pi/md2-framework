define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var CopyTest = declare([_Entity], {
		
		_datatype: "CopyTest",
		
		attributeTypes: {
			attr1: "string",
			attr2: "integer"
		},
		
		_initialize: function() {
			this._attributes = {
				attr1: this._typeFactory.create("string", null),
				attr2: this._typeFactory.create("integer", null)
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "CopyTest",
		
		create: function() {
			return new CopyTest(this.typeFactory);
		}
		
	});
});
