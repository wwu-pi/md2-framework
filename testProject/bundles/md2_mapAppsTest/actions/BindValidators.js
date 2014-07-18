define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator0gk = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget0gl = this.$.widgetRegistry.getWidget("email");
			widget0gl.addValidator(validator0gk);
			
			var validator0gm = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget0gn = this.$.widgetRegistry.getWidget("email");
			widget0gn.addValidator(validator0gm);
			
		}
		
	});
});
