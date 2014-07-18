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
				this.$.widgetRegistry.getWidget("header2").getValue().equals(this.$.create("string", "Actions"))
			) {
				var widget = this.$.widgetRegistry.getWidget("header2");
				var set = this.$.create("string", "Fancy Actions...");
				widget.setValue(set);
			}
			else {
				var widget02 = this.$.widgetRegistry.getWidget("header2");
				var set03 = this.$.create("string", "Actions");
				widget02.setValue(set03);
			}
			
		}
		
	});
});
