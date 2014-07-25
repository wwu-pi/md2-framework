define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action065 = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action065.execute();
			
			var action066 = this.$.actionFactory.getDisableAction("firstName");
			action066.execute();
			
			var action067 = this.$.actionFactory.getGotoViewAction("firstView");
			action067.execute();
			
			var action068 = this.$.actionFactory.getCustomAction("__combined_startAction");
			action068.execute();
			
		}
		
	});
});
