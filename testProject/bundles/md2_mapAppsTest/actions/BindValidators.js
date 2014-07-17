define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator0m9 = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget0ma = this.$.widgetRegistry.getWidget("email");
			widget0ma.addValidator(validator0m9);
			
			var validator0mb = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget0mc = this.$.widgetRegistry.getWidget("email");
			widget0mc.addValidator(validator0mb);
			
		}
		
	});
});
