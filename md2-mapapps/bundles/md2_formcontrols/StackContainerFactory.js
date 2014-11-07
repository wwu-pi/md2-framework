define([
    "dojo/_base/declare",
    "dataform/controls/_Control",
    "dijit/layout/StackContainer"
],
function (declare, _Control, StackContainer) {
    
    var StackContainerControl = declare([_Control], {
        controlClass: "stackcontainer",
        createWidget: function(params) {
            return new StackContainer(params);
        }
    });
    
    return declare([], {
        createFormControl: function(params) {
            return new StackContainerControl(params);
        }
    });
});
