define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindButtons",
		
		execute: function() {
			
			var widget01d = this.$.widgetRegistry.getWidget("butSave");
			var action01e = this.$.actionFactory.getContentProviderOperationAction("customerProvider", "save");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget01d, action01e);
			
			var widget01f = this.$.widgetRegistry.getWidget("butLoad");
			var action01g = this.$.actionFactory.getContentProviderOperationAction("customerProvider", "load");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget01f, action01g);
			
			var widget01h = this.$.widgetRegistry.getWidget("butRemove");
			var action01i = this.$.actionFactory.getContentProviderOperationAction("customerProvider", "remove");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget01h, action01i);
			
			var widget01j = this.$.widgetRegistry.getWidget("butReset");
			var action01k = this.$.actionFactory.getContentProviderResetAction("customerProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget01j, action01k);
			
		}
		
	});
});
