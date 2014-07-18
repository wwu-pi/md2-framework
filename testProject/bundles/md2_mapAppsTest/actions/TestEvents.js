define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget0e = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action0f = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0e, action0f);
			
			var widget0g = this.$.widgetRegistry.getWidget("toggleLastName");
			var action0h = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0g, action0h);
			
			var widget0i = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action0j = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0i, action0j);
			
			var widget0k = this.$.widgetRegistry.getWidget("makeFancyActions");
			var action0l = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0k, action0l);
			
			var widget0m = this.$.widgetRegistry.getWidget("birthdate");
			var action0n = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0m, action0n);
			
			var widget0o = this.$.widgetRegistry.getWidget("email");
			var messageExpression = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0p = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0o, action0p);
			
			var contentProvider = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0r = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0q = this.$.actionFactory.getDisplayMessageAction("39cb0a76f5dbfc2a9a7b411c3c41fd00", messageExpression0r);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider, "firstName", action0q);
			
			var contentProvider0s = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0u = function() {
				return this.$.create("string", "Oh, something happened in the personProvider!").toString();
			};
			var action0t = this.$.actionFactory.getDisplayMessageAction("4d79b7288b263862d1984ffe3f4ade4d", messageExpression0u);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider0s, "*", action0t);
			
		}
		
	});
});
