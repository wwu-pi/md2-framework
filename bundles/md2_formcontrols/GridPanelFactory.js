define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dataform/controls/_Control",
    "dojo/dom-class",
    "dojo/dom-construct",
    "dojo/_base/array",
    "dijit/layout/_LayoutWidget"
], function(d_lang, declare, _Control, domClass, domConstruct, arrayUtil, _LayoutWidget){
    
    var GridLayout = declare([_LayoutWidget], {
        baseClass : "ctGridContainer",
        // summary:
        //		A container that lays out its child widgets in a table layout.
        //
        cols: 1,
        
        // customClass: String
        //		A CSS class that will be applied to child elements.  For example, if
        //		the class is "myClass", the table will have "myClass-table" applied to it,
        //		each label TD will have "myClass-labelCell" applied, and each
        //		widget TD will have "myClass-valueCell" applied.
        customClass: "",
        
        postCreate: function() {
            this._renderedChildren = {};
            this.inherited(arguments);
        },
        
        layout: function() {
            var children = this.getChildren();
            var rootNode = this.domNode;
            
            var maxCols = this.cols;
            var numCols = 0;
            var childRow;
            // Iterate over the children, adding them to the table.
            arrayUtil.forEach(children, function(child, index){
                if(this._renderedChildren[child.get("id")]){
                    child.resize && child.resize();
                    return;
                }
                this._renderedChildren[child.get("id")] = true;
                var colspan = child.colspan || 1;
                
                if(colspan > 1) {
                    colspan = Math.min(maxCols, colspan);
                }
                
                // Create a new row if we need one
                if(!childRow || (numCols + colspan - 1 >= maxCols)) {
                    numCols = 0;
                    childRow = domConstruct.create("div", {
                        "class": "row valueRow"
                    }, rootNode);
                }
                
                var childCell = domConstruct.create("div", {
                    "class": "cell valueCell" + (child.valueClass ? " " + child.valueClass : ""),
                    style: child.cellStyle
                }, childRow);
                
                // Add the widget cell's custom class, if one exists.
                this.addCustomClass(childCell, "valueCell", index);
                
                child.placeAt(childCell);
                
                numCols += colspan;
            }, this);
            if (childRow){
                domClass.add(childRow, "last-row");
            }
        },
        
        addCustomClass:  function (node, type, count) {
            if(this.customClass) {
                var clazz = this.customClass + "-" + (type || node.tagName.toLowerCase());
                domClass.add(node, clazz);
                if(arguments.length > 2) {
                    domClass.add(node, clazz + "-" + count);
                }
            }
        }
    });
    
    var GridPanel = declare([_Control], {
        controlClass : "gridpanel md2gridpanel",
        createWidget: function (params) {
            return new GridLayout(d_lang.mixin(params,{
                cols : this.cols || 1,
                spacing : 0
            }));
        }
    });
    
    /**
    * Actual dataform.ControlFactory interface implementation.
    * @param {Object} widgetParams
    * @returns {GridPanel}
    */
   return declare([], {
       createFormControl: function(widgetParams) {
           return new GridPanel(widgetParams);
       }
   });
});
