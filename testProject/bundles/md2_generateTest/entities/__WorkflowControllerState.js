define([
	"dojo/_base/declare",
	"../../md2_runtime/entities/_Entity"
],
function(declare, _Entity) {
	
	var __WorkflowControllerState = declare([_Entity], {
		
		_datatype: "__WorkflowControllerState",
		
		attributeTypes: {
			currentWorkflowStep: "string",
			lastEventFired: "string"
		},
		
		_initialize: function() {
			this._attributes = {
				currentWorkflowStep: this._typeFactory.create("string", null),
				lastEventFired: this._typeFactory.create("string", null)
			};
		}
		
	});
	
	/**
	 * Entity Factory
	 */
	return declare([], {
		
		datatype: "__WorkflowControllerState",
		
		create: function() {
			return new __WorkflowControllerState(this.typeFactory);
		}
		
	});
});
