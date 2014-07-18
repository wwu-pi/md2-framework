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
				var action0t = this.$.actionFactory.getEnableAction("lastName");
				action0t.execute();
			}
			else {
				var action0u = this.$.actionFactory.getDisableAction("lastName");
				action0u.execute();
			}
			
		}
		
	});
});
