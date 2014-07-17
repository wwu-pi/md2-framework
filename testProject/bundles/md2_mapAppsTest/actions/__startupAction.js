define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action0md = this.$.actionFactory.getDisableAction("firstName");
			action0md.execute();
			
			var action0me = this.$.actionFactory.getGotoViewAction("firstView");
			action0me.execute();
			
			var action0mf = this.$.actionFactory.getCustomAction("__combined_startAction");
			action0mf.execute();
			
		}
		
	});
});
