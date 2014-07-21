define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "doMappings",
		
		execute: function() {
			
			var contentProvider040 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget041 = this.$.widgetRegistry.getWidget("firstName");
			this.$.dataMapper.map(widget041, contentProvider040, "firstName");
			
			var contentProvider042 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget043 = this.$.widgetRegistry.getWidget("lastName");
			this.$.dataMapper.map(widget043, contentProvider042, "firstName");
			
			var contentProvider044 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var widget045 = this.$.widgetRegistry.getWidget("email");
			this.$.dataMapper.map(widget045, contentProvider044, "email");
			
		}
		
	});
});
