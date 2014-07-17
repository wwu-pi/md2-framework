define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testEvents",
		
		execute: function() {
			
			var widget0mq = this.$.widgetRegistry.getWidget("resetPersonProvider");
			var action0mr = this.$.actionFactory.getContentProviderResetAction("personProvider");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0mq, action0mr);
			
			var widget0ms = this.$.widgetRegistry.getWidget("toggleLastName");
			var action0mt = this.$.actionFactory.getCustomAction("toggleEnabled");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0ms, action0mt);
			
			var widget0mu = this.$.widgetRegistry.getWidget("gotoCalculator");
			var action0mv = this.$.actionFactory.getGotoViewAction("calculatorView");
			this.$.eventRegistry.get("widget/onClick").registerAction(widget0mu, action0mv);
			
			var widget0mw = this.$.widgetRegistry.getWidget("makeFancyActions1");
			var action0mx = this.$.actionFactory.getCustomAction("makeActionsFancy");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0mw, action0mx);
			
			var widget0my = this.$.widgetRegistry.getWidget("birthdate");
			var action0mz = this.$.actionFactory.getCustomAction("setName");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0my, action0mz);
			
			var widget0n0 = this.$.widgetRegistry.getWidget("email");
			var messageExpression0n2 = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0n1 = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression0n2);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0n0, action0n1);
			
			var contentProvider0n3 = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0n5 = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address is "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0n4 = this.$.actionFactory.getDisplayMessageAction("3728c6912dc32f11bda60c2e9042f4e4", messageExpression0n5);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider0n3, "firstName", action0n4);
			
		}
		
	});
});
