define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "makeActionsFancy",
		
		execute: function() {
			
			var bool05m = this.$.widgetRegistry.getWidget("makeFancyActions").getValue().equals(this.$.create("boolean", true)) &&
			this.$.widgetRegistry.getWidget("header2").getValue().equals(this.$.create("string", "Actions"));
			if (bool05m) {
				var widget05n = this.$.widgetRegistry.getWidget("header2");
				var set05o = this.$.create("string", "Fancy Actions...");
				widget05n.setValue(set05o);
			}
			else {
				var widget05p = this.$.widgetRegistry.getWidget("header2");
				var set05q = this.$.create("string", "Actions");
				widget05p.setValue(set05q);
			}
			
		}
		
	});
});
