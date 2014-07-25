define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action059 = this.$.actionFactory.getCustomAction("doMappings");
			action059.execute();
			
			var action05a = this.$.actionFactory.getCustomAction("testActions");
			action05a.execute();
			
			var action05b = this.$.actionFactory.getCustomAction("testEvents");
			action05b.execute();
			
			var action05c = this.$.actionFactory.getCustomAction("bindValidators");
			action05c.execute();
			
			var action05d = this.$.actionFactory.getCustomAction("testSetter");
			action05d.execute();
			
			var action05e = this.$.actionFactory.getCustomAction("setterTest");
			action05e.execute();
			
		}
		
	});
});
