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
			
			var widget0d = this.$.widgetRegistry.getWidget("email");
			var messageExpression0f = function() {
				return this.$.create("string", this.$.create("string", "Email Address changed: ").toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0e = this.$.actionFactory.getDisplayMessageAction("17f35191bd82d7c26468d5019216dabb", messageExpression0f);
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0d, action0e);
			
			var contentProvider = this.$.contentProviderRegistry.getContentProvider("personProvider");
			var messageExpression0h = function() {
				return this.$.create("string", this.$.create("string", this.$.contentProviderRegistry.getContentProvider("personProvider").getValue("firstName").toString()
				.concat(this.$.create("string", ", your email address has been changed to "))
				).toString()
				.concat(this.$.widgetRegistry.getWidget("email").getValue())
				).toString();
			};
			var action0g = this.$.actionFactory.getDisplayMessageAction("45d082badc75d19e767ce80cba169b96", messageExpression0h);
			this.$.eventRegistry.get("contentProvider/onChange").registerAction(contentProvider, "firstName", action0g);
			
		}
		
	});
});
