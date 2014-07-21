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
				var targetContentProvider04a = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set04b = this.$.create("string", "John Doe");
				targetContentProvider04a.setValue("firstName", set04b);
			}
			else {
				var targetContentProvider04c = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set04d = this.$.create("string", "Johnny Doe");
				targetContentProvider04c.setValue("firstName", set04d);
			}
			
		}
		
	});
});
