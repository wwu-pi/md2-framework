define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action078 = this.$.actionFactory.getGotoViewAction("firstView");
			action078.execute();
			
			var action079 = this.$.actionFactory.getCustomAction("startAction");
			action079.execute();
			
		}
		
	});
});
