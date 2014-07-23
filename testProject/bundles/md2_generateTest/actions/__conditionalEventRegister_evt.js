define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEventRegister_evt",
		
		execute: function() {
			
			var widget0c2 = this.$.widgetRegistry.getWidget("__firstNameTextInput_29");
			var action0c3 = this.$.actionFactory.getCustomAction("__conditionalEvent_evt");
			this.$.eventRegistry.get("widget/onChange").registerAction(widget0c2, action0c3);
			
		}
		
	});
});
