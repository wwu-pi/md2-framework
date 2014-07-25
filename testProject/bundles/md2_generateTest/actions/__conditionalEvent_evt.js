define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEvent_evt",
		
		execute: function() {
			
			var bool = (
				this.$.widgetRegistry.getWidget("__firstNameTextInput_2").getValue().equals(this.$.create("string", "John")) ||
				this.$.widgetRegistry.getWidget("__firstNameTextInput_2").getValue().equals(this.$.create("string", "Bill"))
			) &&
			this.$.widgetRegistry.getWidget("__lastNameTextInput_2").getValue().equals(this.$.create("string", "Doe"));
			if (bool) {
				var bool015 = this.$.contentProviderRegistry.getContentProvider("__conditionalEventMappingsProvider").getValue("__simple__DisplayMessageAction_d21199be1a3d6d37dc59562c85de9a22__evt").equals(this.$.create("boolean", true));
				if (bool015) {
					var messageExpression = function() {
						return this.$.create("string", this.$.create("string", this.$.create("string", "Dude, I know you!! Your name is ").toString()
						.concat(this.$.contentProviderRegistry.getContentProvider("customer").getValue("firstName"))
						).toString()
						.concat(this.$.create("string", "!"))
						).toString();
					};
					var action016 = this.$.actionFactory.getDisplayMessageAction("d21199be1a3d6d37dc59562c85de9a22", messageExpression);
					action016.execute();
				}
			}
			
		}
		
	});
});
