define(["dojo/_base/lang","dojo/_base/declare","dojo/_base/array","dojo/_base/connect","./TextBox","dijit/form/Button","dojox/image/LightboxNano","dijit/_Widget","dijit/_TemplatedMixin","dijit/_WidgetsInTemplateMixin","dojo/text!./templates/Image.htm"],
    function(d_lang,declare,d_array,d_connect,TextBox,Button,LightboxNano,_Widget,_TemplatedMixin,_WidgetsInTemplateMixin,templateStringContent) {
        return declare([_Widget, _TemplatedMixin,_WidgetsInTemplateMixin],
        {
            templateString: templateStringContent,

            textBoxWidget: null,
            showImageButton: null,
            previewWidget: null,

            formElement: null,
            attributeId: null,
            baseUrl: null,

            constructor: function (args) {
                this.inherited(arguments);

                this.attributeId = args.formElement.AttributeId;
                this.formElement = args.formElement;
                this.baseUrl = args.baseUrl;
            },

            postCreate: function () {
                this.inherited(arguments);

                this.textBoxWidget = new TextBox({
                    formElement: this.formElement
                });
                d_connect.connect(this.textBoxWidget, "onValueChanged", this, this._valueChanged);
                this.textBoxWidget.placeAt(this.textBoxPlaceholder);

                // create preview
                this.previewWidget = new LightboxNano();

                // Create Button
                this.showImageButton = new Button({
                    label: "Vorschau"
                }, this.showImageButtonPlaceholder);
                d_connect.connect(this.showImageButton, "onClick", this, this._onShowImageButtonClick);

            },

            focus: function () {
                this.textBoxWidget.focus();
            },

            setValue: function (value) {
                this.textBoxWidget.set("value", value);
            },

            getValue: function () {
                return this.textBoxWidget.get("value");
            },

            get: function (name) {
                if (name = "value")
                    return this.getValue();
                else {
                    return this.textBoxWidget.get(name);
                }
            },

            bindData: function (data, tableId) {
                this.tableId = tableId;
                var attributeId = this.attributeId;
                var matchingProperties = d_array.filter(data.Properties, function (el) {
                    return el.Id == attributeId;
                });
                this.property = matchingProperties[0];
                this.textBoxWidget.set("value", this.property.Value);
            },

            isValid: function () {
                return true; //always true as the maxLength cannot be exceeded
            },

            _onShowImageButtonClick: function (e) {
                e.preventDefault();
                this.previewWidget.show({
                    href: this.baseUrl + this.textBoxWidget.get("value"),
                    origin: e.target
                });
            },

            _valueChanged: function (event) {
                if (this.property) {
                    var newValue = this.get("value");

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