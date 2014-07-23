define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEvent_evt",
		
		execute: function() {
			
			if (
				(
					this.$.widgetRegistry.getWidget("__firstNameTextInput_5").getValue().equals(this.$.create("string", "John")) ||
					this.$.widgetRegistry.getWidget("__firstNameTextInput_5").getValue().equals(this.$.create("string", "Bill"))
				) &&
				this.$.widgetRegistry.getWidget("__lastNameTextInput_5").getValue().equals(this.$.create("string", "Doe"))
			) {
				if (
					this.$.contentProviderRegistry.getContentProvider("__conditionalEventMappingsProvider").getValue("__simple__DisplayMessageAction_d21199be1a3d6d37dc59562c85de9a22__evt").equals(this.$.create("boolean", true))
				) {
					var messageExpression030 = function() {
						return this.$.create("string", this.$.create("string", this.$.create("string", "Dude, I know you!! Your name is ").toString()
						.concat(this.$.contentProviderRegistry.getContentProvider("customer").getValue("firstName"))
						).toString()
						.concat(this.$.create("string", "!"))
						).toString();
					};
					var action02z = this.$.actionFactory.getDisplayMessageAction("d21199be1a3d6d37dc59562c85de9a22", messageExpression030);
					action02z.execute();
				}
			}
			
		}
		
	});
});
