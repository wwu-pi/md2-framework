define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider01o = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget01p = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget01p, contentProvider01o, "firstName");
			
			var contentProvider01q = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget01r = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget01r, contentProvider01q, "firstName");
			
			var contentProvider01s = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget01t = this.$.widgetRegistry.getWidget("email");
			this.$.dataMapper.map(widget01t, contentProvider01s, "email");
			
		}
		
	});
});
