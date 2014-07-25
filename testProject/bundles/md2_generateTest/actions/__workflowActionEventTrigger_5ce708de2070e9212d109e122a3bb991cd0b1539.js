define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowActionEventTrigger_5ce708de2070e9212d109e122a3bb991cd0b1539",
		
		execute: function() {
			
			var targetContentProvider047 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set048 = this.$.create("string", "__gui.fifthView.prev.onClick");
			targetContentProvider047.setValue("lastEventFired", set048);
			
			var action049 = this.$.actionFactory.getCustomAction("__workflowProcessingAction");
			action049.execute();
			
		}
		
	});
});
