define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action0p = this.$.actionFactory.getDisableAction("firstName");
			action0p.execute();
			
			var action0q = this.$.actionFactory.getGotoViewAction("firstView");
			action0q.execute();
			
			var action0r = this.$.actionFactory.getCustomAction("__combined_startAction");
			action0r.execute();
			
		}
		
	});
});
