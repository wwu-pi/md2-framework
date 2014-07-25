define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTest",
		
		execute: function() {
			
			var targetContentProvider05r = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set05s = this.$.create("string", "This is an attribute!");
			targetContentProvider05r.setValue("attr1", set05s);
			
			var targetContentProvider05t = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set05u = this.$.create("integer", 123);
			targetContentProvider05t.setValue("attr2", set05u);
			
			var messageExpression05w = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action05v = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression05w);
			action05v.execute();
			
			var widget05x = this.$.widgetRegistry.getWidget("copyCopyTest1");
			var action05y = this.$.actionFactory.getCustomAction("setterTestCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget05x, action05y);
			
			var widget05z = this.$.widgetRegistry.getWidget("resetCopyTest2");
			var action060 = this.$.actionFactory.getCustomAction("setterTestResetCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget05z, action060);
			
			var contentProvider061 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget062 = this.$.widgetRegistry.getWidget("attr1");
			this.$.dataMapper.map(widget062, contentProvider061, "attr1");
			
			var contentProvider063 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget064 = this.$.widgetRegistry.getWidget("attr2");
			this.$.dataMapper.map(widget064, contentProvider063, "attr2");
			
		}
		
	});
});
