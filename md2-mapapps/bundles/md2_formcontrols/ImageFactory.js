define([
    "dojo/_base/declare",
    "dojo/dom-construct",
    "ct/_url",
    "dataform/controls/_Control",
    "dijit/_WidgetBase"
],
function (declare, d_domconstruct, ct_url, _Control, _WidgetBase) {
    
    var Image = declare([_WidgetBase], {
        
        buildRendering: function () {
            // calculate height and width relative to container div
            var w = this.imgW;
            var h = this.imgH;
            if (!w && !h) {
                w = 100;
            }
            var dimStyle = (h ? "height:" + h + "%;" : "") + (w ? "width:" + w + "%;" : "");
            
            // get image src
            var src = ct_url.resourceURL(this.src);
            
            var img = d_domconstruct.create("img", {src: src, style: dimStyle});
            var outer = d_domconstruct.create("div", {style: "width:100%;"});
            d_domconstruct.place(img, outer);
            this.domNode = outer;
        }
        
    });
    
    var ImageControl = declare([_Control], {
        
        controlClass: "simpleimage",
        
        createWidget: function(params) {
            return new Image(params);
        }
    });
    
    return declare([], /** @lends dataform.controls.FormControlFactory.prototype */{
        
        createFormControl: function(widgetParams) {
            return new ImageControl(widgetParams);
        }
        
    });
});