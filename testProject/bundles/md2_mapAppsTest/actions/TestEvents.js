define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget06f = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action06g = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget06f, action06g);
			
			var widget06h = this.$.widgetRegistry.getWidget("toggleLastName");
			var action06i = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget06h, action06i);
			
			var widget06j = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action06k = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget06j, action06k);
			
			var widget06l = this.$.widgetRegistry.getWidget("makeFancyActions");
			var action06m = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget06l, action06m);
			
			var widget06n = this.$.widgetRegistry.getWidget("birthdate");
			var action06o = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget06n, action06o);
			
			var widget06p = this.$.widgetRegistry.getWidget("email");
			var messageExpression06r = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action06q = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression06r);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget06p, action06q);
			
			var contentProvider06s = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression06u = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action06t = this.$.actionFactory.getDisplayMessageAction("39cb0a76f5dbfc2a9a7b411c3c41fd00", messageExpression06u);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider06s, "firstName", action06t);
			
			var contentProvider06v = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression06x = function() {
				return this.$.create("string", "Oh, something happened in the personProvider!").toString();
			};
			var action06w = this.$.actionFactory.getDisplayMessageAction("4d79b7288b263862d1984ffe3f4ade4d", messageExpression06x);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider06v, "*", action06w);
			
		}
		
	});
});
