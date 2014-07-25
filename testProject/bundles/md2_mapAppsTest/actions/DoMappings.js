define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider069 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget06a = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget06a, contentProvider069, "firstName");
			
			var contentProvider06b = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget06c = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget06c, contentProvider06b, "firstName");
			
			var contentProvider06d = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget06e = this.$.widgetRegistry.getWidget("email");
			this.$.dataMapper.map(widget06e, contentProvider06d, "email");
			
		}
		
	});
});
