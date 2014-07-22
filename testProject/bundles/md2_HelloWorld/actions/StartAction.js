define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "startAction",
		
		execute: function() {
			
			var action01b = this.$.actionFactory.getCustomAction("bindButtons");
			action01b.execute();
			
			var action01c = this.$.actionFactory.getCustomAction("mapFields");
			action01c.execute();
			
		}
		
	});
});
