define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget02v = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action02w = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget02v, action02w);
			
			var widget02x = this.$.widgetRegistry.getWidget("toggleLastName");
			var action02y = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget02x, action02y);
			
			var widget02z = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action030 = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget02z, action030);
			
			var widget031 = this.$.widgetRegistry.getWidget("makeFancyActions");
			var action032 = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget031, action032);
			
			var widget033 = this.$.widgetRegistry.getWidget("birthdate");
			var action034 = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget033, action034);
			
			var widget035 = this.$.widgetRegistry.getWidget("email");
			var messageExpression037 = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action036 = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression037);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget035, action036);
			
			var contentProvider038 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression03a = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action039 = this.$.actionFactory.getDisplayMessageAction("39cb0a76f5dbfc2a9a7b411c3c41fd00", messageExpression03a);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider038, "firstName", action039);
			
			var contentProvider03b = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression03d = function() {
				return this.$.create("string", "Oh, something happened in the personProvider!").toString();
			};
			var action03c = this.$.actionFactory.getDisplayMessageAction("4d79b7288b263862d1984ffe3f4ade4d", messageExpression03d);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider03b, "*", action03c);
			
		}
		
	});
});
