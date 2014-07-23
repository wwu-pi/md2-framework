define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "registerOnConditionEvent",
		
		execute: function() {
			
			var targetContentProvider0c0 = this.$.contentProviderRegistry.getContentProvider("__conditionalEventMappingsProvider");
			var set0c1 = this.$.create("boolean", true);
			targetContentProvider0c0.setValue("__simple__DisplayMessageAction_1fe519c7936c4d3acfd70860153a0ec9__evt", set0c1);
			
		}
		
	});
});
