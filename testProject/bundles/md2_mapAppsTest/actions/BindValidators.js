define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget01u = this.$.widgetRegistry.getWidget("email");
			widget01u.addValidator(validator);
			
			var validator01v = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget01w = this.$.widgetRegistry.getWidget("email");
			widget01w.addValidator(validator01v);
			
		}
		
	});
});
