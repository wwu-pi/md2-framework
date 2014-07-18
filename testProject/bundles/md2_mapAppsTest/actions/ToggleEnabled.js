define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "toggleEnabled",
		
		execute: function() {
			
			if (
				this.$.widgetRegistry.getWidget("lastName").isDisabled()
			) {
				var action07 = this.$.actionFactory.getEnableAction("lastName");
				action07.execute();
			}
			else {
				var action08 = this.$.actionFactory.getDisableAction("lastName");
				action08.execute();
			}
			
		}
		
	});
});
