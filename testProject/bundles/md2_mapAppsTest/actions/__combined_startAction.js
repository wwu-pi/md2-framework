define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action09 = this.$.actionFactory.getCustomAction("doMappings");
			action09.execute();
			
			var action0a = this.$.actionFactory.getCustomAction("testActions");
			action0a.execute();
			
			var action0b = this.$.actionFactory.getCustomAction("testEvents");
			action0b.execute();
			
			var action0c = this.$.actionFactory.getCustomAction("bindValidators");
			action0c.execute();
			
			var action0d = this.$.actionFactory.getCustomAction("testSetter");
			action0d.execute();
			
		}
		
	});
});
