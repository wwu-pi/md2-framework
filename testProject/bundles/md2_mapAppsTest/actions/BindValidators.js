define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator04p = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget04q = this.$.widgetRegistry.getWidget("email");
			widget04q.addValidator(validator04p);
			
			var validator04r = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget04s = this.$.widgetRegistry.getWidget("email");
			widget04s.addValidator(validator04r);
			
		}
		
	});
});
