define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTest",
		
		execute: function() {
			
			var targetContentProvider03m = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set03n = this.$.create("string", "This is an attribute!");
			targetContentProvider03m.setValue("attr1", set03n);
			
			var targetContentProvider03o = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set03p = this.$.create("integer", 123);
			targetContentProvider03o.setValue("attr2", set03p);
			
			var messageExpression03r = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action03q = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression03r);
			action03q.execute();
			
			var widget03s = this.$.widgetRegistry.getWidget("copyCopyTest1");
			var action03t = this.$.actionFactory.getCustomAction("setterTestCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget03s, action03t);
			
			var widget03u = this.$.widgetRegistry.getWidget("resetCopyTest2");
			var action03v = this.$.actionFactory.getCustomAction("setterTestResetCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget03u, action03v);
			
			var contentProvider03w = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget03x = this.$.widgetRegistry.getWidget("attr1");
			this.$.dataMapper.map(widget03x, contentProvider03w, "attr1");
			
			var contentProvider03y = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget03z = this.$.widgetRegistry.getWidget("attr2");
			this.$.dataMapper.map(widget03z, contentProvider03y, "attr2");
			
		}
		
	});
});
