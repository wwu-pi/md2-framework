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
				var action0mo = this.$.actionFactory.getEnableAction("lastName");
				action0mo.execute();
			}
			else {
				var action0mp = this.$.actionFactory.getDisableAction("lastName");
				action0mp.execute();
			}
			
		}
		
	});
});
