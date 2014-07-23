define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__autoGenerationAction",
		
		execute: function() {
			
			var contentProvider0ay = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0az = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_29");
			this.$.dataMapper.map(widget0az, contentProvider0ay, "customerID");
			
			var contentProvider0b0 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0b1 = this.$.widgetRegistry.getWidget("__firstNameTextInput_29");
			this.$.dataMapper.map(widget0b1, contentProvider0b0, "firstName");
			
			var contentProvider0b2 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0b3 = this.$.widgetRegistry.getWidget("__lastNameTextInput_29");
			this.$.dataMapper.map(widget0b3, contentProvider0b2, "lastName");
			
			var contentProvider0b4 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0b5 = this.$.widgetRegistry.getWidget("__residenceTextInput_29");
			this.$.dataMapper.map(widget0b5, contentProvider0b4, "residence");
			
			var contentProvider0b6 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0b7 = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_29");
			this.$.dataMapper.map(widget0b7, contentProvider0b6, "expectedSales");
			
			var contentProvider0b8 = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0b9 = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_29");
			this.$.dataMapper.map(widget0b9, contentProvider0b8, "dateOfBirth");
			
			var contentProvider0ba = this.$.contentProviderRegistry.getContentProvider("customer");
			var widget0bb = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_29");
			this.$.dataMapper.map(widget0bb, contentProvider0ba, "ownsProperty");
			
			var validator0bc = this.$.validatorFactory.getNotNullValidator();
			var widget0bd = this.$.widgetRegistry.getWidget("__customerIDIntegerInput_29");
			widget0bd.addValidator(validator0bc);
			
			var validator0be = this.$.validatorFactory.getNotNullValidator();
			var widget0bf = this.$.widgetRegistry.getWidget("__residenceTextInput_29");
			widget0bf.addValidator(validator0be);
			
			var validator0bg = this.$.validatorFactory.getNotNullValidator();
			var widget0bh = this.$.widgetRegistry.getWidget("__expectedSalesNumberInput_29");
			widget0bh.addValidator(validator0bg);
			
			var validator0bi = this.$.validatorFactory.getNotNullValidator();
			var widget0bj = this.$.widgetRegistry.getWidget("__dateOfBirthDateInput_29");
			widget0bj.addValidator(validator0bi);
			
			var validator0bk = this.$.validatorFactory.getNotNullValidator();
			var widget0bl = this.$.widgetRegistry.getWidget("__ownsPropertyBooleanInput_29");
			widget0bl.addValidator(validator0bk);
			
		}
		
	});
});
