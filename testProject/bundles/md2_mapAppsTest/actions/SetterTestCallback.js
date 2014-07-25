define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTestCallback",
		
		execute: function() {
			
			var targetContentProvider05f = this.$.contentProviderRegistry.getContentProvider("copyTest2");
			var set05g = this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent();
			targetContentProvider05f.setContent(set05g);
			
			var action05h = this.$.actionFactory.getDisableAction("copyCopyTest1");
			action05h.execute();
			
			var action05i = this.$.actionFactory.getEnableAction("resetCopyTest2");
			action05i.execute();
			
			var messageExpression05k = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action05j = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression05k);
			action05j.execute();
			
			var action05l = this.$.actionFactory.getContentProviderOperationAction("copyTest2", "save");
			action05l.execute();
			
		}
		
	});
});
