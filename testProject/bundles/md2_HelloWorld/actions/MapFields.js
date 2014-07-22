define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "mapFields",
		
		execute: function() {
			
			var contentProvider01n = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget01o = this.$.widgetRegistry.getWidget("formId");
			this.$.dataMapper.map(widget01o, contentProvider01n, "id");
			
			var contentProvider01p = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget01q = this.$.widgetRegistry.getWidget("formFirstName");
			this.$.dataMapper.map(widget01q, contentProvider01p, "firstName");
			
			var contentProvider01r = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget01s = this.$.widgetRegistry.getWidget("formLastName");
			this.$.dataMapper.map(widget01s, contentProvider01r, "lastName");
			
		}
		
	});
});
