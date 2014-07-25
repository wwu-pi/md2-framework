define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__registerWorkflowActionEventTrigger",
		
		execute: function() {
			
			var widget030 = this.$.widgetRegistry.getWidget("next");
			var action031 = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_677bcd38126c2b277b777f785d321a0894ab39a5");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget030, action031);
			
			var widget032 = this.$.widgetRegistry.getWidget("prev");
			var action033 = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_5ce708de2070e9212d109e122a3bb991cd0b1539");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget032, action033);
			
			var widget034 = this.$.widgetRegistry.getWidget("prev1");
			var action035 = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_90363878099ecf8465aaa9c31dd40836d87bf657");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget034, action035);
			
			var widget036 = this.$.widgetRegistry.getWidget("continue");
			var action037 = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_bbc2a4e497d9addeb461525eca209c1a9d8318bb");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget036, action037);
			
			var widget038 = this.$.widgetRegistry.getWidget("returnTo3");
			var action039 = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_95d500bd5356e0abe9941f0d19265525bd7fafc5");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget038, action039);
			
			var contentProvider03a = this.$.contentProviderRegistry.getContentProvider("customer");
			var action03b = this.$.actionFactory.getCustomAction("__workflowActionEventTrigger_cfe85f46120c5939ec296ec8d9bbe5e4370e85b7");
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider03a, "expectedSales", action03b);
			
		}
		
	});
});
