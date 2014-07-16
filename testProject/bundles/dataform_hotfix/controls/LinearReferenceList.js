define(["dojo/_base/lang","dojo/_base/declare","dojo/_base/array","dijit/_Widget","dijit/_TemplatedMixin","dijit/_WidgetsInTemplateMixin","dijit/form/FilteringSelect","dojox/data/JsonRestStore","dojo/data/ObjectStore","dojo/text!./templates/LinearReferenceList.htm"],
    function(d_lang,declare,d_array,_Widget,_TemplatedMixin,_WidgetsInTemplateMixin,FilteringSelect,JsonRestStore,ObjectStore,templateStringContent) {
        /*
        * COPYRIGHT 2012 con terra GmbH Germany
        */
        /**
        * @fileOverview This is a widget for displaying data of type ReferenceListField (linear).
        * @author Ilya Gorodnyanskiy, Andreas Runze
        */
        return declare([_Widget, _TemplatedMixin,_WidgetsInTemplateMixin],
        {
            templateString: templateStringContent,
            filteringSelect: null,

            attributeId: null,
            baseUrl: null,
            formElement: null,
            hasDownArrow: true,
            isValidationRequired: true,

            /**
            * @constructs
            * @param args args-object including: formElement, baseUrl
            */
            constructor: function (args) {
                this.formElement = args.formElement;
                this.attributeId = args.formElement.AttributeId;
                this.searchAttribute = "Term";
                this.labelAttribute = "ResultTerm";

                this.baseUrl = args.baseUrl;

                // down arrow
                if (args.hasDownArrow != null)
                    this.hasDownArrow = args.hasDownArrow;

                if (args.isValidationRequired != null)
                    this.isValidationRequired = args.isValidationRequired;
            },

            postCreate: function () {
                this.inherited(arguments);

                var url = this.baseUrl + this.formElement.ReferenceListName + "/Items/Selectable/";
                this.jsonRestStore = new JsonRestStore({
                    target: url,
                    idAttribute: "EntityId"
                });

                if (this.isValidationRequired == true)
                    this.filteringSelect = new FilteringSelect({
                        hasDownArrow: this.hasDownArrow,
                        store: this.jsonRestStore,
                        query: {
                            id: "*"
                        },
                        searchAttr: this.searchAttribute,
                        labelAttr: this.labelAttribute
                    }, this.filteringSelectPlaceholder);
                else
                    this.filteringSelect = new FilteringSelect({
                        hasDownArrow: this.hasDownArrow,
                        store: this.jsonRestStore,
                        query: {
                            id: "*"
                        },
                        searchAttr: this.searchAttribute,
                        labelAttr: this.labelAttribute,
                        required: this.isValidationRequired,
                        validate: function () {
                            return true;
                        }
                    }, this.filteringSelectPlaceholder);

                this.connect(this.filteringSelect, "onChange", this._valueChanged);
            },

            focus: function () {
                this.filteringSelect.focus();
            },

            /**
            * Interface member
            */
            bindData: function (data, tableId) {
                this.tableId = tableId;
                var attributeId = this.attributeId;
                var matchingProperties = d_array.filter(data.Properties, function (el) {
                    return el.Id == attributeId;
                });
                this.property = matchingProperties[0];
                this.setValue(this.property.Value);
            },

            setValue: function (value) {
                this.filteringSelect.set("value", value);


            //        this.jsonRestStore.get(value).then(function (item) {
            //            this.filteringSelect.set("value", item);
            //        });
            },

            getValue: function () {
                // var item = this.filteringSelect.get("value");
                var item = this.filteringSelect.item;
                if (item) {
                    if (item.ResultEntityId) {
                        return item.ResultEntityId;
                    }
                    return item.EntityId;
                }
                return null;
            },

            get: function (name) {
                if (name = "value")
                    return this.getValue();
                else {
                    return this.filteringSelect.get(name);
                }
            },

            isValid: function () {
                return (this.filteringSelect.get("value") != null);
            },

            _valueChanged: function (newValue) {
                if (this.property) {
                    this.property.Value = newValue;
                    this.onValueChanged({
                        src: this,
                        value: newValue
                    });
                }
            },

            onValueChanged: function (event) { }

        });
    });