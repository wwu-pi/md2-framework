define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var __ConditionalEventMappings = declare([_Entity], {
		
		_datatype: "__ConditionalEventMappings",
		
		attributeTypes: {
			__simple__DisplayMessageAction_1fe519c7936c4d3acfd70860153a0ec9__evt: "boolean"
		},
		
		_initialize: function() {
			this._attributes = {
				__simple__DisplayMessageAction_1fe519c7936c4d3acfd70860153a0ec9__evt: this._typeFactory.create("boolean", false)
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
