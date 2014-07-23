define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__autoGenerationAction",
		
		execute: function() {
			
			var contentProvider01f = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01g = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_5");
			this.$.dataMapper.map(widget01g, contentProvider01f, "customerID");
			
			var contentProvider01h = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01i = this.$.widgetRegistry.getWidget("__firstNameTextInput_5");
			this.$.dataMapper.map(widget01i, contentProvider01h, "firstName");
			
			var contentProvider01j = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01k = this.$.widgetRegistry.getWidget("__lastNameTextInput_5");
			this.$.dataMapper.map(widget01k, contentProvider01j, "lastName");
			
			var contentProvider01l = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01m = this.$.widgetRegistry.getWidget("__residenceTextInput_5");
			this.$.dataMapper.map(widget01m, contentProvider01l, "residence");
			
			var contentProvider01n = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01o = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_5");
			this.$.dataMapper.map(widget01o, contentProvider01n, "expectedSales");
			
			var contentProvider01p = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01q = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_5");
			this.$.dataMapper.map(widget01q, contentProvider01p, "dateOfBirth");
			
			var contentProvider01r = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget01s = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_5");
			this.$.dataMapper.map(widget01s, contentProvider01r, "ownsProperty");
			
			var validator01t = this.$.validatorFactory.getNotNullValidator();
			var widget01u = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_5");
			widget01u.addValidator(validator01t);
			
			var validator01v = this.$.validatorFactory.getNotNullValidator();
			var widget01w = this.$.widgetRegistry.getWidget("__residenceTextInput_5");
			widget01w.addValidator(validator01v);
			
			var validator01x = this.$.validatorFactory.getNotNullValidator();
			var widget01y = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_5");
			widget01y.addValidator(validator01x);
			
			var validator01z = this.$.validatorFactory.getNotNullValidator();
			var widget020 = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_5");
			widget020.addValidator(validator01z);
			
			var validator021 = this.$.validatorFactory.getNotNullValidator();
			var widget022 = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_5");
			widget022.addValidator(validator021);
			
		}
		
	});
});
