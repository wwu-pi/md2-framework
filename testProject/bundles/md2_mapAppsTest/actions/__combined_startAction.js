define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action01x = this.$.actionFactory.getCustomAction("doMappings");
			action01x.execute();
			
			var action01y = this.$.actionFactory.getCustomAction("testActions");
			action01y.execute();
			
			var action01z = this.$.actionFactory.getCustomAction("testEvents");
			action01z.execute();
			
			var action020 = this.$.actionFactory.getCustomAction("bindValidators");
			action020.execute();
			
			var action021 = this.$.actionFactory.getCustomAction("testSetter");
			action021.execute();
			
			var action022 = this.$.actionFactory.getCustomAction("setterTest");
			action022.execute();
			
		}
		
	});
});
