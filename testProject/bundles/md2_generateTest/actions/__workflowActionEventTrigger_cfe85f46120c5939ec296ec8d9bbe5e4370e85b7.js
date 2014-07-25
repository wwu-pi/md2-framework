define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_cfe85f46120c5939ec296ec8d9bbe5e4370e85b7",
		
		execute: function() {
			
			var targetContentProvider03c = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set03d = this.$.create("string", "__contentProvider.customer.expectedSales.onChange");
			targetContentProvider03c.setValue("lastEventFired", set03d);
			
			var action03e = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action03e.execute();
			
		}
		
	});
});
