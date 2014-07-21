define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "bindValidators",
		
		execute: function() {
			
			var validator02n = this.$.validatorFactory.getNotNullValidator("Email field must not be empty!");
			var widget02o = this.$.widgetRegistry.getWidget("email");
			widget02o.addValidator(validator02n);
			
			var validator02p = this.$.validatorFactory.getRegExValidator(".+@.+", "Have you ever seen an email address without @?");
			var widget02q = this.$.widgetRegistry.getWidget("email");
			widget02q.addValidator(validator02p);
			
		}
		
	});
});
