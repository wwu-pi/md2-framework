define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action08 = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget, action08);
			
			var widget09 = this.$.widgetRegistry.getWidget("toggleLastName");
			var action0a = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget09, action0a);
			
			var widget0b = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action0c = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0b, action0c);
			
			var widget0d = this.$.widgetRegistry.getWidget("makeFancyActions");
			var action0e = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0d, action0e);
			
			var widget0f = this.$.widgetRegistry.getWidget("birthdate");
			var action0g = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0f, action0g);
			
			var widget0h = this.$.widgetRegistry.getWidget("email");
			var messageExpression0j = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0i = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression0j);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0h, action0i);
			
			var contentProvider = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0l = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0k = this.$.actionFactory.getDisplayMessageAction("39cb0a76f5dbfc2a9a7b411c3c41fd00", messageExpression0l);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider, "firstName", action0k);
			
			var contentProvider0m = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0o = function() {
				return this.$.create("string", "Oh, something happened in the personProvider!").toString();
			};
			var action0n = this.$.actionFactory.getDisplayMessageAction("4d79b7288b263862d1984ffe3f4ade4d", messageExpression0o);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider0m, "*", action0n);
			
		}
		
	});
});
