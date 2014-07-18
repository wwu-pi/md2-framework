define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider016 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget017 = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget017, contentProvider016, "firstName");
			
			var contentProvider018 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget019 = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget019, contentProvider018, "firstName");
			
			var contentProvider01a = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget01b = this.$.widgetRegistry.getWidget("email");
			this.$.dataMapper.map(widget01b, contentProvider01a, "email");
			
		}
		
	});
});
