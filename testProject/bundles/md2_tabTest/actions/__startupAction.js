define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action05 = this.$.actionFactory.getGotoViewAction("tabView");
			action05.execute();
			
			var action06 = this.$.actionFactory.getCustomAction("startAction");
			action06.execute();
			
		}
		
	});
});
