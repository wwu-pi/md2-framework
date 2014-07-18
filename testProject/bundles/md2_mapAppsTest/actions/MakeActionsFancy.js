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
				var widget0ff = this.$.widgetRegistry.getWidget("header1");
				var set0fg = this.$.create("string", "Fancy Actions...");
				widget0ff.setValue(set0fg);
			}
			else {
				var widget0fh = this.$.widgetRegistry.getWidget("header1");
				var set0fi = this.$.create("string", "Actions");
				widget0fh.setValue(set0fi);
			}
			
		}
		
	});
});
