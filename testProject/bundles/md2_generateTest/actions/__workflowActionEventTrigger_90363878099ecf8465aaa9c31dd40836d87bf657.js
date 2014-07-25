define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_90363878099ecf8465aaa9c31dd40836d87bf657",
		
		execute: function() {
			
			var targetContentProvider0u = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set0v = this.$.create("string", "__gui.fourthView.prev.onClick");
			targetContentProvider0u.setValue("lastEventFired", set0v);
			
			var action0w = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action0w.execute();
			
		}
		
	});
});
