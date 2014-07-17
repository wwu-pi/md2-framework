define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "makeActionsFancy",
		
		execute: function() {
			
			if (
				this.$.widgetRegistry.getWidget("makeFancyActions1").getValue().equals(this.$.create("boolean", true)) &&
				this.$.widgetRegistry.getWidget("header2").getValue().equals(this.$.create("string", "Actions"))
			) {
				var widget0nf = this.$.widgetRegistry.getWidget("header2");
				var set0ng = this.$.create("string", "Fancy Actions...");
				widget0nf.setValue(set0ng);
			}
			else {
				var widget0nh = this.$.widgetRegistry.getWidget("header2");
				var set0ni = this.$.create("string", "Actions");
				widget0nh.setValue(set0ni);
			}
			
		}
		
	});
});
