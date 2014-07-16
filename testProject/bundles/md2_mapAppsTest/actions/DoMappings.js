define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider0i = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0j = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget0j, contentProvider0i, "firstName");
			
			var contentProvider0k = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0l = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget0l, contentProvider0k, "firstName");
			
		}
		
	});
});
