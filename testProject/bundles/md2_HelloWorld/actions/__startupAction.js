define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action01l = this.$.actionFactory.getGotoViewAction("firstView");
			action01l.execute();
			
			var action01m = this.$.actionFactory.getCustomAction("startAction");
			action01m.execute();
			
		}
		
	});
});
