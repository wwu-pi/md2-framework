define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action0m = this.$.actionFactory.getCustomAction("doMappings");
			action0m.execute();
			
			var action0n = this.$.actionFactory.getCustomAction("testActions");
			action0n.execute();
			
			var action0o = this.$.actionFactory.getCustomAction("testEvents");
			action0o.execute();
			
		}
		
	});
});
