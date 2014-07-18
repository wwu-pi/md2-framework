define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget04 = this.$.widgetRegistry.getWidget("email");
			widget04.addValidator(validator);
			
			var validator05 = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget06 = this.$.widgetRegistry.getWidget("email");
			widget06.addValidator(validator05);
			
		}
		
	});
});
