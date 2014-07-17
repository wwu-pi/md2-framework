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
				var targetContentProvider0nj = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set0nk = this.$.create("string", "John Doe");
				targetContentProvider0nj.setValue("firstName", set0nk);
			}
			else {
				var targetContentProvider0nl = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set0nm = this.$.create("string", "Johnny Doe");
				targetContentProvider0nl.setValue("firstName", set0nm);
			}
			
		}
		
	});
});
