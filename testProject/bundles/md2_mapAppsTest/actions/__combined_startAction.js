define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action025 = this.$.actionFactory.getCustomAction("doMappings");
			action025.execute();
			
			var action026 = this.$.actionFactory.getCustomAction("testActions");
			action026.execute();
			
			var action027 = this.$.actionFactory.getCustomAction("testEvents");
			action027.execute();
			
			var action028 = this.$.actionFactory.getCustomAction("bindValidators");
			action028.execute();
			
			var action029 = this.$.actionFactory.getCustomAction("testSetter");
			action029.execute();
			
			var action02a = this.$.actionFactory.getCustomAction("setterTest");
			action02a.execute();
			
		}
		
	});
});
