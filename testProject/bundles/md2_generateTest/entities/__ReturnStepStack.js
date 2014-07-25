define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var __ReturnStepStack = declare([_Entity], {
		
		_datatype: "__ReturnStepStack",
		
		attributeTypes: {
			returnStep: "string",
			returnAndReverseStep: "string",
			returnAndProceedStep: "string",
			tail: "__ReturnStepStack"
		},
		
		_initialize: function() {
			this._attributes = {
				returnStep: this._typeFactory.create("string", null),
				returnAndReverseStep: this._typeFactory.create("string", null),
				returnAndProceedStep: this._typeFactory.create("string", null),
				tail: null
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "__ReturnStepStack",
		
		create: function() {
			return new __ReturnStepStack(this.typeFactory);
		}
		
	});
});
