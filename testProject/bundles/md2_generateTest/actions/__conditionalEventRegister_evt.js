define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEventRegister_evt",
		
		execute: function() {
			
			var widget = this.$.widgetRegistry.getWidget("__firstNameTextInput_2");
			var action = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget, action);
			
			var widget00 = this.$.widgetRegistry.getWidget("__firstNameTextInput_2");
			var action01 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget00, action01);
			
			var widget02 = this.$.widgetRegistry.getWidget("__lastNameTextInput_2");
			var action03 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget02, action03);
			
		}
		
	});
});
