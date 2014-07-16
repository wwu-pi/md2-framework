define([
    "dojo/_base/declare",
    "ct/Exception",
    "./TabPanel",
    "./BorderPanel",
    "./AccordionPanel",
    "./TablePanel",
    "./GridPanel",
    "./WizardPanel",
    "./Panel",
    "./Label",
    "./TextBox",
    "./CheckBox",
    "./RadioButton",
    "./NumberTextBox",
    "./NumberSpinner",
    "./TimeTextBox",
    "./DateTextBox",
    "./Textarea",
    "./ComboBox",
    "./SelectBox",
    "./Uploader",
    "./Button",
    "./Slider",
    "./Switch",
    "./ColorPicker",
    "./ToggleButton"
], function(declare, Exception, TabPanel, BorderPanel, AccordionPanel, TablePanel, GridPanel, WizardPanel, Panel, Label, TextBox, CheckBox, RadioButton, NumberTextBox, NumberSpinner, TimeTextBox, DateTextBox, Textarea, ComboBox, SelectBox, Uploader, Button, Slider, Switch, ColorPicker, ToggleButton) {
    /*
     * COPYRIGHT 2012 con terra GmbH Germany
     */
    /**
     * @fileOverview This is a factory class for all control widgets.
     */
    var FormControls;
    return FormControls = declare([], /** @lends dataform.controls.FormControlFactory.prototype */{
        
        // static global controls
        controls: {
            "panel": Panel,
            "tabpanel": TabPanel,
            "borderpanel": BorderPanel,
            "accordionpanel": AccordionPanel,
            "tablepanel": TablePanel,
            "gridpanel": GridPanel,
            "wizardpanel": WizardPanel,
            "label": Label,
            "textbox": TextBox,
            "checkbox": CheckBox,
            "radiobutton": RadioButton,
            "numbertextbox": NumberTextBox,
            "numberspinner": NumberSpinner,
            "timetextbox": TimeTextBox,
            "datetextbox": DateTextBox,
            "textarea": Textarea,
            "combobox": ComboBox,
            "selectbox": SelectBox,
            "uploader": Uploader,
            "button": Button,
            //TODO better numberslider or can it handle different datatypes?
            "slider": Slider,
            "switch": Switch,
            "colorpicker": ColorPicker,
            "togglebutton": ToggleButton
                    /*"image" : Image,
                     
                     "grid" : DataGrid,
                     "referencelist" : LinearReferenceList,
                     "hierarchicreferencelist" : HierarchicReferenceList*/
        },
        constructor: function() {
            this.controlFactories = this.controlFactories || {};
            console.log(this.controlFactories);
        },
        addControlFactory: function(factory, properties) {
            var type = properties.dataformtype || factory.type;
            if (!type) {
                console.error("dataform/controls/FormControls: addControlFactory missing property 'dataformtype'!", properties);
                return;
            }
            
            this.controlFactories[type] = factory;
            console.log(this.controlFactories);
        },
        removeControlFactory: function(factory, properties) {
            var type = properties.dataformtype || factory.type;
            if (!type) {
                return;
            }
            delete this.controlFactories[type];
        },
        createFormControl: function(type, widgetParams) {
            var factory = this.controlFactories[type];
            if (factory) {
                //TODO: support component factory pattern? or keep it as own interface?
                if (factory.createFormControl) {
                    return factory.createFormControl(widgetParams);
                }
                throw Exception.illegalArgumentError("FormControlFactory: control type '" + type + "' has registered factory without 'createFormControl' method!");
            }
            var ControlType = this.controls[type];
            if (!ControlType) {
                throw Exception.illegalArgumentError("FormControlFactory: control type '" + type + "' is not registered!");
            }
            return new ControlType(widgetParams);
        },
        // use in grid
        createFormControlInfo: function(type, widgetParams) {

        }
    });
});