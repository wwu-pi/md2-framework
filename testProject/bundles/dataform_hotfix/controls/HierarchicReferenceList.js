define(["dojo/_base/lang","dojo/_base/declare","dojo/_base/array","dojo/_base/connect","dijit/_Widget","dijit/_TemplatedMixin","dijit/_WidgetsInTemplateMixin","./LinearReferenceList","dijit/form/Button","dijit/Dialog","dojo/text!./templates/HierarchicReferenceList.htm"],
    function(d_lang,declare,d_array,d_connect,_Widget,_TemplatedMixin,_WidgetsInTemplateMixin,LinearReferenceList,Button,Dialog,templateStringContent) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a widget for displaying data of type ReferenceListField.
        */
        return declare([_Widget, _TemplatedMixin,_WidgetsInTemplateMixin],
        {
            templateString: templateStringContent,

            //embedded widgets
            linearReferenceListWidget: null,
            referenceListTreeWidget: null,
            showReferenceListButton: null,
            referenceListDialog: null,

            // other attributes
            attributeId: null,
            baseUrl: null,
            formElement: null,
            filterValue: null,

            /**
            * @constructs
            * @param args args-object including: formElement, baseUrl
            */
            constructor: function (args) {
                this.formElement = args.formElement;
                this.baseUrl = args.baseUrl;
            },

            // initializes embedded widgets and sets up
            // the widget
            postCreate: function () {
                this.inherited(arguments);


                // Create linear reference list widget
                this.linearReferenceListWidget = new LinearReferenceList({
                    formElement: this.formElement,
                    baseUrl: this.baseUrl,
                    hasDownArrow: false
                });
                d_connect.connect(this.linearReferenceListWidget, "onValueChanged", this, this.onFilterValueChanged);
                this.linearReferenceListWidget.placeAt(this.linearReferenceListPlaceholder);
                // Create Button
                this.showReferenceListButton = new Button({
                    label: "..."
                }, this.showReferenceListButtonPlaceholder);
                d_connect.connect(this.showReferenceListButton, "onClick", this, this._onShowReferenceListClick);

            // Create reference list tree widget
            /*

                this.referenceListTreeWidget = new ReferenceListTree();
                this.referenceListTreeWidget.SetBaseServiceUrl(this.baseUrl);
                // create dialog for list presentation
                this.referenceListDialog = new Dialog({
                    title: this.formElement.ReferenceListName,
                    content: this.referenceListTreeWidget,
                    style: "height: 500px; width:400px; overflow: auto"
                });
                // sturt up the reference list (create tree)
                this.referenceListTreeWidget.LoadReferenceList(this.formElement.ReferenceListName, "", "");
                // connect to the double click event of the tree
                d_connect.connect(this.referenceListTreeWidget, "onDoubleClick", this, this._onItemSelected);
                */
            },

            focus: function () {
                this.linearReferenceListWidget.focus();
            },

            /**
            * Interface member
            */
            bindData: function (data, tableId) {
                /*  this.tableId = tableId;
                var attributeId = this.attributeId;
                var matchingProperties = d_array.filter(data.Properties, function (el) {
                return el.Id == attributeId;
                });
                this.property = matchingProperties[0];
                this.setValue(this.property.Value); */
                this.linearReferenceListWidget.bindData(data, tableId);
            },


            setValue: function (value) {
                this.linearReferenceListWidget.setValue(value);
            },


            getValue: function () {
                return this.linearReferenceListWidget.getValue();
            },

            get: function (name) {
                if (name = "value")
                    return this.getValue();
                else {
                    return this.linearReferenceListWidget.get(name);
                }
            },

            /**
            * Interface member
            * @see FormControl
            */
            isValid: function () {
                return this.linearReferenceListWidget.isValid();
            },

            // the value of the linear reference list widget has changed
            onFilterValueChanged: function (event) {
                this.filterValue = event.value;
            },

            // Submit button is clicked
            _onShowReferenceListClick: function (event) {
                this.referenceListDialog.show();
                if (this.filterValue)
                    this.referenceListTreeWidget.SelectNodeById(this.filterValue);
            },

            _onItemSelected: function (event) {
                this.linearReferenceListWidget.setValue(event.selectedItem.EntityId);
                this.referenceListDialog.hide();
            },

            /**
            * Interface member
            * @see FormControl
            */
            onValueChanged: function (event) { },

            _valueChanged: function (newValue) {
                this.onValueChanged({
                    src: this,
                    value: newValue
                });
            }
        });
    });