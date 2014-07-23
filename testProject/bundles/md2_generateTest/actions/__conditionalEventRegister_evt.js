define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEventRegister_evt",
		
		execute: function() {
			
			var widget023 = this.$.widgetRegistry.getWidget("__firstNameTextInput_5");
			var action024 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget023, action024);
			
			var widget025 = this.$.widgetRegistry.getWidget("__firstNameTextInput_5");
			var action026 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget025, action026);
			
			var widget027 = this.$.widgetRegistry.getWidget("__lastNameTextInput_5");
			var action028 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget027, action028);
			
		}
		
	});
});
