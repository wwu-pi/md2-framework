define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider0fj = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0fk = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget0fk, contentProvider0fj, "firstName");
			
			var contentProvider0fl = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0fm = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget0fm, contentProvider0fl, "firstName");
			
			var contentProvider0fn = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0fo = this.$.widgetRegistry.getWidget("email");
			this.$.dataMapper.map(widget0fo, contentProvider0fn, "email");
			
		}
		
	});
});
