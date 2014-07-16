define(["dojo/_base/declare","./ComboBox"],
    function(declare,ComboBox) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a select box widget, only values in the store can be selected.
        */
        return declare([ComboBox],
        {
            controlClass : "selectbox",
            onlyPreDefinedValues : true
        });
    });