define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "mapFields",
		
		execute: function() {
			
			var contentProvider070 = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget071 = this.$.widgetRegistry.getWidget("formId");
			this.$.dataMapper.map(widget071, contentProvider070, "id");
			
			var contentProvider072 = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget073 = this.$.widgetRegistry.getWidget("formFirstName");
			this.$.dataMapper.map(widget073, contentProvider072, "firstName");
			
			var contentProvider074 = this.$.contentProviderRegistry.getContentProvider("customerProvider");
			var widget075 = this.$.widgetRegistry.getWidget("formLastName");
			this.$.dataMapper.map(widget075, contentProvider074, "lastName");
			
		}
		
	});
});
