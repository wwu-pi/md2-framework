define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "startWf",
		
		execute: function() {
			
			var widget03k = this.$.widgetRegistry.getWidget("startWf");
			var action03l = this.$.actionFactory.getCustomAction("__workflowSetWorkflowMyWfAction");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget03k, action03l);
			
		}
		
	});
});
