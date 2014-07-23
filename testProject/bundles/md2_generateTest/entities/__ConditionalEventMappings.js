define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var __ConditionalEventMappings = declare([_Entity], {
		
		_datatype: "__ConditionalEventMappings",
		
		attributeTypes: {
			__simple__DisplayMessageAction_d21199be1a3d6d37dc59562c85de9a22__evt: "boolean"
		},
		
		_initialize: function() {
			this._attributes = {
				__simple__DisplayMessageAction_d21199be1a3d6d37dc59562c85de9a22__evt: this._typeFactory.create("boolean", false)
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "__ConditionalEventMappings",
		
		create: function() {
			return new __ConditionalEventMappings(this.typeFactory);
		}
		
	});
});
