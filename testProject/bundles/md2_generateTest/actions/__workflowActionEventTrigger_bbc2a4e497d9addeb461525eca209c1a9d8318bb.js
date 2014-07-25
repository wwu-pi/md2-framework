define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_bbc2a4e497d9addeb461525eca209c1a9d8318bb",
		
		execute: function() {
			
			var targetContentProvider03m = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set03n = this.$.create("string", "__gui.thirdView.continue.onClick");
			targetContentProvider03m.setValue("lastEventFired", set03n);
			
			var action03o = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action03o.execute();
			
		}
		
	});
});
