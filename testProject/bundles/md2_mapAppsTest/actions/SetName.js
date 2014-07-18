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
				var set0v = this.$.create("string", "John Doe");
				targetContentProvider.setValue("firstName", set0v);
			}
			else {
				var targetContentProvider0w = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set0x = this.$.create("string", "Johnny Doe");
				targetContentProvider0w.setValue("firstName", set0x);
			}
			
		}
		
	});
});
