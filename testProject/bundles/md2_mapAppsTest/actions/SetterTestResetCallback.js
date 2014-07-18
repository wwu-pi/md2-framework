define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestResetCallback",
		
		execute: function() {
			
			var action01j = this.$.actionFactory.getContentProviderResetAction("copyTest2");
			action01j.execute();
			
			var action01k = this.$.actionFactory.getEnableAction("copyCopyTest1");
			action01k.execute();
			
			var action01l = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action01l.execute();
			
			var messageExpression01n = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action01m = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression01n);
			action01m.execute();
			
		}
		
	});
});
