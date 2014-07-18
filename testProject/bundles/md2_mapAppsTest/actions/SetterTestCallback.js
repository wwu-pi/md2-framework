define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestCallback",
		
		execute: function() {
			
			var targetContentProvider019 = this.$.contentProviderRegistry.getContentProvider("copyTest2");
			var set01a = this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent();
			targetContentProvider019.setContent(set01a);
			
			var action01b = this.$.actionFactory.getDisableAction("copyCopyTest1");
			action01b.execute();
			
			var action01c = this.$.actionFactory.getEnableAction("resetCopyTest2");
			action01c.execute();
			
			var messageExpression01e = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action01d = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression01e);
			action01d.execute();
			
		}
		
	});
});
