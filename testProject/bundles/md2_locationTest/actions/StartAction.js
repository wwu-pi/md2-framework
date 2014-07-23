define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "startAction",
		
		execute: function() {
			
			var contentProvider0g = this.$.contentProviderRegistry.getContentProvider("location");
			var widget0h = this.$.widgetRegistry.getWidget("cityValue");
			this.$.dataMapper.map(widget0h, contentProvider0g, "city");
			
			var contentProvider0i = this.$.contentProviderRegistry.getContentProvider("location");
			var widget0j = this.$.widgetRegistry.getWidget("streetValue");
			this.$.dataMapper.map(widget0j, contentProvider0i, "street");
			
			var messageExpression0l = function() {
				return this.$.create("string", "Location updated!").toString();
			};
			var action0k = this.$.actionFactory.getDisplayMessageAction("13550943b30fe8d72761d3eff31cbe8f", messageExpression0l);
			this.$.eventRegistry.get("global/onLocationUpdate").registerAction(action0k);
			
			var widget0m = this.$.widgetRegistry.getWidget("loadCurrentLocation");
			var action0n = this.$.actionFactory.getContentProviderOperationAction("location", "load");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0m, action0n);
			
		}
		
	});
});
