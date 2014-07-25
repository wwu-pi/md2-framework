define([
	"dojo/_base/declare",
	"dojo/date/stamp",
	"../../md2_runtime/actions/_Action"
],
function(declare, stamp, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setName",
		
		execute: function() {
			
			var bool054 = this.$.widgetRegistry.getWidget("birthdate").getValue().lt(this.$.create("date", stamp.fromISOString("2000-01-01")));
			if (bool054) {
				var targetContentProvider055 = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set056 = this.$.create("string", "John Doe");
				targetContentProvider055.setValue("firstName", set056);
			}
			else {
				var targetContentProvider057 = this.$.contentProviderRegistry.getContentProvider("personProvider");
				var set058 = this.$.create("string", "Johnny Doe");
				targetContentProvider057.setValue("firstName", set058);
			}
			
		}
		
	});
});
