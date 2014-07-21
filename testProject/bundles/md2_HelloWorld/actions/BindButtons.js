define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindButtons",
		
		execute: function() {
			
			var widget07a = this.$.widgetRegistry.getWidget("butSave");
			var action07b = this.$.actionFactory.getContentProviderOperationAction("customerProvider", "save");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget07a, action07b);
			
			var widget07c = this.$.widgetRegistry.getWidget("butLoad");
			var action07d = this.$.actionFactory.getContentProviderOperationAction("customerProvider", "load");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget07c, action07d);
			
			var widget07e = this.$.widgetRegistry.getWidget("butReset");
			var action07f = this.$.actionFactory.getContentProviderResetAction("customerProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget07e, action07f);
			
		}
		
	});
});
