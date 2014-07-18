define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestResetCallback",
		
		execute: function() {
			
			var action0em = this.$.actionFactory.getContentProviderResetAction("copyTest2");
			action0em.execute();
			
			var action0en = this.$.actionFactory.getEnableAction("copyCopyTest1");
			action0en.execute();
			
			var action0eo = this.$.actionFactory.getDisableAction("resetCopyTest2");
			action0eo.execute();
			
			var messageExpression0eq = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action0ep = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression0eq);
			action0ep.execute();
			
		}
		
	});
});
