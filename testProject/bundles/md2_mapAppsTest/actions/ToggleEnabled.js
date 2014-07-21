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
				var action04e = this.$.actionFactory.getEnableAction("lastName");
				action04e.execute();
			}
			else {
				var action04f = this.$.actionFactory.getDisableAction("lastName");
				action04f.execute();
			}
			
		}
		
	});
});
