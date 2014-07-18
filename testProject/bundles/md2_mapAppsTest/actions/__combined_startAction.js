define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__combined_startAction",
		
		execute: function() {
			
			var action0fp = this.$.actionFactory.getCustomAction("doMappings");
			action0fp.execute();
			
			var action0fq = this.$.actionFactory.getCustomAction("testActions");
			action0fq.execute();
			
			var action0fr = this.$.actionFactory.getCustomAction("testEvents");
			action0fr.execute();
			
			var action0fs = this.$.actionFactory.getCustomAction("bindValidators");
			action0fs.execute();
			
			var action0ft = this.$.actionFactory.getCustomAction("testSetter");
			action0ft.execute();
			
			var action0fu = this.$.actionFactory.getCustomAction("setterTest");
			action0fu.execute();
			
		}
		
	});
});
