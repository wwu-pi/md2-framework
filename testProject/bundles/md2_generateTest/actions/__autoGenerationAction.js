define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__autoGenerationAction",
		
		execute: function() {
			
			var contentProvider = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget04 = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_2");
			this.$.dataMapper.map(widget04, contentProvider, "customerID");
			
			var contentProvider05 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget06 = this.$.widgetRegistry.getWidget("__firstNameTextInput_2");
			this.$.dataMapper.map(widget06, contentProvider05, "firstName");
			
			var contentProvider07 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget08 = this.$.widgetRegistry.getWidget("__lastNameTextInput_2");
			this.$.dataMapper.map(widget08, contentProvider07, "lastName");
			
			var contentProvider09 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0a = this.$.widgetRegistry.getWidget("__residenceTextInput_2");
			this.$.dataMapper.map(widget0a, contentProvider09, "residence");
			
			var contentProvider0b = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0c = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_2");
			this.$.dataMapper.map(widget0c, contentProvider0b, "expectedSales");
			
			var contentProvider0d = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0e = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_2");
			this.$.dataMapper.map(widget0e, contentProvider0d, "dateOfBirth");
			
			var contentProvider0f = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0g = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_2");
			this.$.dataMapper.map(widget0g, contentProvider0f, "ownsProperty");
			
			var validator = this.$.validatorFactory.getNotNullValidator();
			var widget0h = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_2");
			widget0h.addValidator(validator);
			
			var validator0i = this.$.validatorFactory.getNotNullValidator();
			var widget0j = this.$.widgetRegistry.getWidget("__residenceTextInput_2");
			widget0j.addValidator(validator0i);
			
			var validator0k = this.$.validatorFactory.getNotNullValidator();
			var widget0l = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_2");
			widget0l.addValidator(validator0k);
			
			var validator0m = this.$.validatorFactory.getNotNullValidator();
			var widget0n = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_2");
			widget0n.addValidator(validator0m);
			
			var validator0o = this.$.validatorFactory.getNotNullValidator();
			var widget0p = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_2");
			widget0p.addValidator(validator0o);
			
		}
		
	});
});
