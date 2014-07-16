define([
    "dojo/_base/declare",
    "dijit/_Widget",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/MainWidget.html"
    ],
    function(declare, _Widget, _TemplatedMixin, _WidgetsInTemplateMixin, templateStringContent) {
        return declare([_Widget, _TemplatedMixin, _WidgetsInTemplateMixin], {
            templateString: templateStringContent
        });
    });
    