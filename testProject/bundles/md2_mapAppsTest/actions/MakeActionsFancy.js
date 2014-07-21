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
				var widget02r = this.$.widgetRegistry.getWidget("header1");
				var set02s = this.$.create("string", "Fancy Actions...");
				widget02r.setValue(set02s);
			}
			else {
				var widget02t = this.$.widgetRegistry.getWidget("header1");
				var set02u = this.$.create("string", "Actions");
				widget02t.setValue(set02u);
			}
			
		}
		
	});
});
