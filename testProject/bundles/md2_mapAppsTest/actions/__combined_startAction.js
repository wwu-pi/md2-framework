define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action0n6 = this.$.actionFactory.getCustomAction("doMappings");
			action0n6.execute();
			
			var action0n7 = this.$.actionFactory.getCustomAction("testActions");
			action0n7.execute();
			
			var action0n8 = this.$.actionFactory.getCustomAction("testEvents");
			action0n8.execute();
			
			var action0n9 = this.$.actionFactory.getCustomAction("bindValidators");
			action0n9.execute();
			
			var action0na = this.$.actionFactory.getCustomAction("testSetter");
			action0na.execute();
			
		}
		
	});
});
