define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action = this.$.actionFactory.getGotoViewAction("tabNo2");
			action.execute();
			
			var action00 = this.$.actionFactory.getCustomAction("startAction");
			action00.execute();
			
		}
		
	});
});
