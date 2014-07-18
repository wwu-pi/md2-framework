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
				var targetContentProvider0gg = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set0gh = this.$.create("string", "John Doe");
				targetContentProvider0gg.setValue("firstName", set0gh);
			}
			else {
				var targetContentProvider0gi = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set0gj = this.$.create("string", "Johnny Doe");
				targetContentProvider0gi.setValue("firstName", set0gj);
			}
			
		}
		
	});
});
