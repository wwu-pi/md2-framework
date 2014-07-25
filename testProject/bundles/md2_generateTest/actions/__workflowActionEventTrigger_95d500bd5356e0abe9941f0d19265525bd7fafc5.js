define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_95d500bd5356e0abe9941f0d19265525bd7fafc5",
		
		execute: function() {
			
			var targetContentProvider03v = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set03w = this.$.create("string", "__gui.fifthView.returnTo3.onClick");
			targetContentProvider03v.setValue("lastEventFired", set03w);
			
			var action03x = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action03x.execute();
			
		}
		
	});
});
