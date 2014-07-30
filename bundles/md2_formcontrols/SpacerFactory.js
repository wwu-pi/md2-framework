define([
    "dojo/_base/declare",
    "dataform/controls/_Control",
    "dijit/_WidgetBase"
],
function (declare, _Control, _WidgetBase) {
    
    var Spacer = declare([_WidgetBase], {
        // plain node without any content
    });
    
    var SpacerControl = declare([_Control], {
        controlClass: "spacerwidget",
        createWidget: function(params) {
            return new Spacer(params);
        }
    });
    
    /**
     * Actual dataform.ControlFactory interface implementation.
     * @param {Object} widgetParams
     * @returns {SpacerControl}
     */
    return declare([], {
        createFormControl: function(widgetParams) {
            return new SpacerControl(widgetParams);
        }
    });
});