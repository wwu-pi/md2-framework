define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTest",
		
		execute: function() {
			
			var targetContentProvider0f1 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set0f2 = this.$.create("string", "This is an attribute!");
			targetContentProvider0f1.setValue("attr1", set0f2);
			
			var targetContentProvider0f3 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set0f4 = this.$.create("integer", 123);
			targetContentProvider0f3.setValue("attr2", set0f4);
			
			var messageExpression0f6 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action0f5 = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression0f6);
			action0f5.execute();
			
			var widget0f7 = this.$.widgetRegistry.getWidget("copyCopyTest1");
			var action0f8 = this.$.actionFactory.getCustomAction("setterTestCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0f7, action0f8);
			
			var widget0f9 = this.$.widgetRegistry.getWidget("resetCopyTest2");
			var action0fa = this.$.actionFactory.getCustomAction("setterTestResetCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0f9, action0fa);
			
			var contentProvider0fb = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget0fc = this.$.widgetRegistry.getWidget("attr1");
			this.$.dataMapper.map(widget0fc, contentProvider0fb, "attr1");
			
			var contentProvider0fd = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget0fe = this.$.widgetRegistry.getWidget("attr2");
			this.$.dataMapper.map(widget0fe, contentProvider0fd, "attr2");
			
		}
		
	});
});
