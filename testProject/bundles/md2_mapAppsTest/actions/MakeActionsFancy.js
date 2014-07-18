define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "makeActionsFancy",
		
		execute: function() {
			
			if (
				this.$.widgetRegistry.getWidget("makeFancyActions").getValue().equals(this.$.create("boolean", true)) &&
				this.$.widgetRegistry.getWidget("header1").getValue().equals(this.$.create("string", "Actions"))
			) {
				var widget0p = this.$.widgetRegistry.getWidget("header1");
				var set0q = this.$.create("string", "Fancy Actions...");
				widget0p.setValue(set0q);
			}
			else {
				var widget0r = this.$.widgetRegistry.getWidget("header1");
				var set0s = this.$.create("string", "Actions");
				widget0r.setValue(set0s);
			}
			
		}
		
	});
});
