define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_677bcd38126c2b277b777f785d321a0894ab39a5",
		
		execute: function() {
			
			var targetContentProvider03s = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set03t = this.$.create("string", "__gui.fourthView.next.onClick");
			targetContentProvider03s.setValue("lastEventFired", set03t);
			
			var action03u = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action03u.execute();
			
		}
		
	});
});
