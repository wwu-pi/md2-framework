define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "startAction",
		
		execute: function() {
			
			var action076 = this.$.actionFactory.getCustomAction("bindButtons");
			action076.execute();
			
			var action077 = this.$.actionFactory.getCustomAction("mapFields");
			action077.execute();
			
		}
		
	});
});
