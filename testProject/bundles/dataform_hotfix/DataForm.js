define([
    "dojo/_base/declare", "dojo/dom-class", "dojo/_base/html","dijit/_Widget", "dijit/_TemplatedMixin", "dijit/_WidgetsInTemplateMixin", "dijit/layout/BorderContainer", "dojo/text!./templates/DataForm.htm"
], function(declare, domClass, d_html, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, BorderContainer, templateStringContent) {
    return declare([_Widget, _TemplatedMixin, _WidgetsInTemplateMixin], {
        templateString: templateStringContent,
        baseClass: "ctDataForm",
        bodyControl: null,
        dataFormService: null,
        _topicValidationStateChanged: "dataform/validationStateChanged",
        postCreate: function() {
            var bodyControl = this.bodyControl;
            var formCssClass = bodyControl.get("formCssClass");
            if (formCssClass){
                domClass.add(this.domNode,formCssClass);
            }
            bodyControl.set("rootWidget", this);
            this.body.set("content", bodyControl.get("widget"));
            this.inherited(arguments);
        },
        startup: function() {
            if (this._started) {
                return;
            }
            //TODO: support for header/left/right/footer bars!
            var size = this.bodyControl.get("size");
            if (size && size.h && size.w) {
                this.resize({
                    w: size.w,
                    h: size.h
                });
            }
            this.inherited(arguments);
        },
        resize: function(dim) {
            if (dim && dim.w && dim.h) {
                d_html.marginBox(this.domNode, dim);
            }
            if (!this._started) {
                //TODO: support for header/left/right/footer bars!
                this.bodyControl.set("size", dim);
            }
            this.borderContainer.resize(dim);
        },
        _setDataBindingAttr: function(dataBinding) {
            this.bodyControl.set("dataBinding", dataBinding);
        },
        _getDataBindingAttr: function() {
            return this.bodyControl.get("dataBinding");
        },
        _setHeaderWidgetAttr: function(widget) {
            this.header.set("content", widget);
        },
        _setFooterWidgetAttr: function(widget) {
            this.footer.set("content", widget);
        },
        _setLeftSidebarWidgetAttr: function(widget) {
            this.left.set("content", widget);
        },
        _setRightSidebarWidgetAttr: function(widget) {
            this.right.set("content", widget);
        },
        // called by controlls to fire custom events
        _fireEvent: function(evt) {
            if (evt.topic === this._topicValidationStateChanged) {
                this.onValidationStateChanged({valid: this.isValid()});
                return;
            }
            this.onControlEvent(evt);
        },
        // called by controls to resolve stores
        _resolveStoreEntry: function(storeId) {
            return this.dataFormService.resolveStoreEntry(this, storeId);
        },
        /**
         * @event
         * @param evt.topic the event name, defined by the control
         * @param evt.control the source control of the event
         */
        onControlEvent: function(evt) {
        },
        /**
         * @event
         */
        onValidationStateChanged: function(evt) {

        },
        /**
         * checks if all controls are in a valid state.
         */
        isValid: function() {
            return this.bodyControl.isValid();
        },
        uninitialize: function() {
            // this clears all connects to the databinding
            this.bodyControl.set("dataBinding");
            this.dataFormService = null;
            this.inherited(arguments);
        }
    });
});