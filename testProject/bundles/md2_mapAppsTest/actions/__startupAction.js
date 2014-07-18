define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action01f = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action01f.execute();
			
			var action01g = this.$.actionFactory.getDisableAction("firstName");
			action01g.execute();
			
			var action01h = this.$.actionFactory.getGotoViewAction("firstView");
			action01h.execute();
			
			var action01i = this.$.actionFactory.getCustomAction("__combined_startAction");
			action01i.execute();
			
		}
		
	});
});
