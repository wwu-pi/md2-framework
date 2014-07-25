define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "toggleEnabled",
		
		execute: function() {
			
			var bool04t = this.$.widgetRegistry.getWidget("lastName").isDisabled();
			if (bool04t) {
				var action04u = this.$.actionFactory.getEnableAction("lastName");
				action04u.execute();
			}
			else {
				var action04v = this.$.actionFactory.getDisableAction("lastName");
				action04v.execute();
			}
			
		}
		
	});
});
