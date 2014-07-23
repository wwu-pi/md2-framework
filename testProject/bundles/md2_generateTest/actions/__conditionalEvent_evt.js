define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__conditionalEvent_evt",
		
		execute: function() {
			
			if (
				this.$.widgetRegistry.getWidget("__firstNameTextInput_29").getValue().equals(this.$.create("string", "John"))
			) {
				if (
					this.$.contentProviderRegistry.getContentProvider("__conditionalEventMappingsProvider").getValue("__simple__DisplayMessageAction_1fe519c7936c4d3acfd70860153a0ec9__evt").equals(this.$.create("boolean", true))
				) {
					var messageExpression0bn = function() {
						return this.$.create("string", "Your name is John!").toString();
					};
					var action0bm = this.$.actionFactory.getDisplayMessageAction("1fe519c7936c4d3acfd70860153a0ec9", messageExpression0bn);
					action0bm.execute();
				}
			}
			
		}
		
	});
});
