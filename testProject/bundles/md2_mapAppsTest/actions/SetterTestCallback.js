define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestCallback",
		
		execute: function() {
			
			var targetContentProvider02g = this.$.contentProviderRegistry.getContentProvider("copyTest2");
			var set02h = this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent();
			targetContentProvider02g.setContent(set02h);
			
			var action02i = this.$.actionFactory.getDisableAction("copyCopyTest1");
			action02i.execute();
			
			var action02j = this.$.actionFactory.getEnableAction("resetCopyTest2");
			action02j.execute();
			
			var messageExpression02l = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action02k = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression02l);
			action02k.execute();
			
			var action02m = this.$.actionFactory.getContentProviderOperationAction("copyTest2", "save");
			action02m.execute();
			
		}
		
	});
});
