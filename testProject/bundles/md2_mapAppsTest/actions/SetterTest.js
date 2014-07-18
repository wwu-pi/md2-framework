define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "setterTest",
		
		execute: function() {
			
			var targetContentProvider0v = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set0w = this.$.create("string", "This is an attribute!");
			targetContentProvider0v.setValue("attr1", set0w);
			
			var targetContentProvider0x = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var set0y = this.$.create("integer", 123);
			targetContentProvider0x.setValue("attr2", set0y);
			
			var messageExpression010 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "copyTest1: ").toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest1").getContent())
				).toString()
				.concat(this.$.create("string", "  copyTest2: "))
				).toString()
				.concat(this.$.contentProviderRegistry.getContentProvider("copyTest2").getContent())
				).toString();
			};
			var action0z = this.$.actionFactory.getDisplayMessageAction("76d91fe66c0480ce7da8f83b28a9a1b2", messageExpression010);
			action0z.execute();
			
			var widget011 = this.$.widgetRegistry.getWidget("copyCopyTest1");
			var action012 = this.$.actionFactory.getCustomAction("setterTestCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget011, action012);
			
			var widget013 = this.$.widgetRegistry.getWidget("resetCopyTest2");
			var action014 = this.$.actionFactory.getCustomAction("setterTestResetCallback");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget013, action014);
			
			var contentProvider015 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget016 = this.$.widgetRegistry.getWidget("attr1");
			this.$.dataMapper.map(widget016, contentProvider015, "attr1");
			
			var contentProvider017 = this.$.contentProviderRegistry.getContentProvider("copyTest1");
			var widget018 = this.$.widgetRegistry.getWidget("attr2");
			this.$.dataMapper.map(widget018, contentProvider017, "attr2");
			
		}
		
	});
});
