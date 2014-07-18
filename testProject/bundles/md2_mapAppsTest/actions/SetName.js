define([
	"dojo/_base/declare",
	"dojo/date/stamp",
	"../../md2_runtime/actions/_Action"
],
function(declare, stamp, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setName",
		
		execute: function() {
			
			if (
				this.$.widgetRegistry.getWidget("birthdate").getValue().lt(this.$.create("date", stamp.fromISOString("2000-01-01")))
			) {
				var targetContentProvider = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set = this.$.create("string", "John Doe");
				targetContentProvider.setValue("firstName", set);
			}
			else {
				var targetContentProvider00 = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set01 = this.$.create("string", "Johnny Doe");
				targetContentProvider00.setValue("firstName", set01);
			}
			
		}
		
	});
});
