define([
    "dojo/_base/declare",
    "../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
    
    return declare([_Action], {
        
        _actionSignature: "startAction",
        
        execute: function() {
            
            this.$.actionFactory.getGotoViewAction("startView").execute();
            
            var startView$outerPanel$firstName = this.$.widgetRegistry.getWidget("startView$outerPanel$firstName");
            var customerProvider = this.$.contentProviderRegistry.getContentProvider("customerProvider");
            this.$.dataMapper.map(startView$outerPanel$firstName, customerProvider, "firstName");
            
            var startView$outerPanel$lastName = this.$.widgetRegistry.getWidget("startView$outerPanel$lastName");
            this.$.dataMapper.map(startView$outerPanel$lastName, customerProvider, "lastName");
            
            var startView$outerPanel$customerId = this.$.widgetRegistry.getWidget("startView$outerPanel$customerId");
            this.$.dataMapper.map(startView$outerPanel$customerId, customerProvider, "customerId");
            
            var startView$outerPanel$dateOfBirth = this.$.widgetRegistry.getWidget("startView$outerPanel$dateOfBirth");
            this.$.dataMapper.map(startView$outerPanel$dateOfBirth, customerProvider, "dateOfBirth");
            
            var startView$outerPanel$customerId = this.$.widgetRegistry.getWidget("startView$outerPanel$customerId");
            this.$.dataMapper.unmap(startView$outerPanel$customerId, customerProvider, "customerId");
            
            var startView$outerPanel$lastName = this.$.widgetRegistry.getWidget("startView$outerPanel$lastName");
            this.$.dataMapper.map(startView$outerPanel$lastName, customerProvider, "firstName");
            
            var startView$outerPanel$juhu = this.$.widgetRegistry.getWidget("startView$outerPanel$juhu");
            this.$.dataMapper.map(startView$outerPanel$juhu, customerProvider, "firstName");
            
            //this.$.dataAction("customerProvider", "load");
            
            var myConnectionIsGoneAction = this.$.actionFactory.getCustomAction("myConnectionIsGone");
            this.$.eventRegistry.get("global/onConnectionLost").registerAction(myConnectionIsGoneAction);
            
            //this.$.actionFactory.getGotoViewAction("anotherView").execute();
            
            var anotherView$firstName = this.$.widgetRegistry.getWidget("anotherView$firstName");
            this.$.dataMapper.map(anotherView$firstName, customerProvider, "firstName");
            
            var msgAction = this.$.actionFactory.getDisplayMessageAction("You changed the first name field.");
            this.$.eventRegistry.get("contentProvider/onChange").registerAction(customerProvider, "firstName", msgAction);
            
            var msgAction2 = this.$.actionFactory.getDisplayMessageAction("You clicked a button.");
            var button = this.$.widgetRegistry.getWidget("anotherView$button");
            this.$.eventRegistry.get("widget/onClick").registerAction(button, msgAction2);
            
            var gotoStartView = this.$.actionFactory.getGotoViewAction("startView");
            this.$.eventRegistry.get("widget/onClick").registerAction(button, gotoStartView);
            
            var val1 = this.$.validatorFactory.getNotNullValidator();
            var val2 = this.$.validatorFactory.getNotNullValidator("Don't be so lazy, you have to enter a value here...");
            var val3 = this.$.validatorFactory.getRegExValidator("[a-zA-Z]+");
            var val4 = this.$.validatorFactory.getStringRangeValidator(3, 7);
            var w = this.$.widgetRegistry.getWidget("startView$outerPanel$firstName");
            w.addValidator(val1);
            w.addValidator(val2);
            w.addValidator(val3);
            w.addValidator(val4);
            
        }
        
    });
});
