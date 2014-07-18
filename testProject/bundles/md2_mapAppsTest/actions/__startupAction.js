define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action = this.$.actionFactory.getDisableAction("firstName");
			action.execute();
			
			var action00 = this.$.actionFactory.getGotoViewAction("firstView");
			action00.execute();
			
			var action01 = this.$.actionFactory.getCustomAction("__combined_startAction");
			action01.execute();
			
		}
		
	});
});
