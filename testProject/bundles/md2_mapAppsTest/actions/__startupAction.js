define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action046 = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action046.execute();
			
			var action047 = this.$.actionFactory.getDisableAction("firstName");
			action047.execute();
			
			var action048 = this.$.actionFactory.getGotoViewAction("firstView");
			action048.execute();
			
			var action049 = this.$.actionFactory.getCustomAction("__combined_startAction");
			action049.execute();
			
		}
		
	});
});
