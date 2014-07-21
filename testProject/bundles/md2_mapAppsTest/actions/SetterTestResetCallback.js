define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestResetCallback",
		
		execute: function() {
			
			var action02b = this.$.actionFactory.getContentProviderResetAction("copyTest2");
			action02b.execute();
			
			var action02c = this.$.actionFactory.getEnableAction("copyCopyTest1");
			action02c.execute();
			
			var action02d = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action02d.execute();
			
			var messageExpression02f = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action02e = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression02f);
			action02e.execute();
			
		}
		
	});
});
