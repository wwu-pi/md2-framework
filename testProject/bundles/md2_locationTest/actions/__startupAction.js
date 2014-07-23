define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action0o = this.$.actionFactory.getGotoViewAction("firstView");
			action0o.execute();
			
			var action0p = this.$.actionFactory.getCustomAction("startAction");
			action0p.execute();
			
		}
		
	});
});
