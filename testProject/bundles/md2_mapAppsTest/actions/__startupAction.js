define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__startupAction",
		
		execute: function() {
			
			var action0er = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action0er.execute();
			
			var action0es = this.$.actionFactory.getDisableAction("firstName");
			action0es.execute();
			
			var action0et = this.$.actionFactory.getGotoViewAction("firstView");
			action0et.execute();
			
			var action0eu = this.$.actionFactory.getCustomAction("__combined_startAction");
			action0eu.execute();
			
		}
		
	});
});
