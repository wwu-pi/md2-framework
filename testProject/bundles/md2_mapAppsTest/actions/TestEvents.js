define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget0fv = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action0fw = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0fv, action0fw);
			
			var widget0fx = this.$.widgetRegistry.getWidget("toggleLastName");
			var action0fy = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0fx, action0fy);
			
			var widget0fz = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action0g0 = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0fz, action0g0);
			
			var widget0g1 = this.$.widgetRegistry.getWidget("makeFancyActions");
			var action0g2 = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0g1, action0g2);
			
			var widget0g3 = this.$.widgetRegistry.getWidget("birthdate");
			var action0g4 = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0g3, action0g4);
			
			var widget0g5 = this.$.widgetRegistry.getWidget("email");
			var messageExpression0g7 = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0g6 = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression0g7);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0g5, action0g6);
			
			var contentProvider0g8 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0ga = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0g9 = this.$.actionFactory.getDisplayMessageAction("39cb0a76f5dbfc2a9a7b411c3c41fd00", messageExpression0ga);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider0g8, "firstName", action0g9);
			
			var contentProvider0gb = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0gd = function() {
				return this.$.create("string", "Oh, something happened in the personProvider!").toString();
			};
			var action0gc = this.$.actionFactory.getDisplayMessageAction("4d79b7288b263862d1984ffe3f4ade4d", messageExpression0gd);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider0gb, "*", action0gc);
			
		}
		
	});
});
