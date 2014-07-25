define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestResetCallback",
		
		execute: function() {
			
			var action06y = this.$.actionFactory.getContentProviderResetAction("copyTest2");
			action06y.execute();
			
			var action06z = this.$.actionFactory.getEnableAction("copyCopyTest1");
			action06z.execute();
			
			var action070 = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action070.execute();
			
			var messageExpression072 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action071 = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression072);
			action071.execute();
			
		}
		
	});
});
