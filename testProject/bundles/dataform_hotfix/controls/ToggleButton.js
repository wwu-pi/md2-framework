define([
    "dojo/_base/declare",
    "./CheckBox",
    "dijit/form/ToggleButton"
    ],
    function(declare, CheckBox, ToggleButton) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a toggleButton widget.
        */
        return declare([CheckBox],
        {
            controlClass : "togglebutton",

            createWidget : function (params) {
                return new ToggleButton(params);
            }

        });
    });