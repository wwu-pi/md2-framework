define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowSetWorkflowMyWfAction",
		
		execute: function() {
			
			var targetContentProvider03p = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
			var set03q = this.$.create("string", "myWf__step1");
			targetContentProvider03p.setValue("currentWorkflowStep", set03q);
			
			var action03r = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
			action03r.execute();
			
		}
		
	});
});
