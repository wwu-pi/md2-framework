define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider0nb = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0nc = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget0nc, contentProvider0nb, "firstName");
			
			var contentProvider0nd = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget0ne = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget0ne, contentProvider0nd, "firstName");
			
		}
		
	});
});
