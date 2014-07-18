define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestCallback",
		
		execute: function() {
			
			var targetContentProvider0ev = this.$.contentProviderRegistry.getContentProvider("copyTest2");
			var set0ew = this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent();
			targetContentProvider0ev.setContent(set0ew);
			
			var action0ex = this.$.actionFactory.getDisableAction("copyCopyTest1");
			action0ex.execute();
			
			var action0ey = this.$.actionFactory.getEnableAction("resetCopyTest2");
			action0ey.execute();
			
			var messageExpression0f0 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action0ez = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression0f0);
			action0ez.execute();
			
		}
		
	});
});
