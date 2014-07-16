define(["dojo/_base/lang","ct/_lang","dojo/_base/declare","./_Control","dojo/dom-class", "dojo/dom-construct","dojo/_base/array", "dojo/dom-geometry","dijit/layout/_LayoutWidget"],
    function(d_lang,ct_lang,declare,_Control, domClass, domConstruct, arrayUtil, domGeometry,_LayoutWidget){

        var GridLayout = declare([_LayoutWidget], {
            baseClass : "ctGridContainer",
            // summary:
            //		A container that lays out its child widgets in a table layout.
            //
            cols: 1,

            labelClass: "label",

            // showLabels: Boolean
            //		True if labels should be displayed, false otherwise.
            showLabels: true,

            // orientation: String
            //		Either "horiz" or "vert" for label orientation.
            orientation: "horiz",

            // customClass: String
            //		A CSS class that will be applied to child elements.  For example, if
            //		the class is "myClass", the table will have "myClass-table" applied to it,
            //		each label TD will have "myClass-labelCell" applied, and each
            //		widget TD will have "myClass-valueCell" applied.
            customClass: "",

            postCreate: function(){
                this._renderedChildren = {};
                this.inherited(arguments);
            },

            layout: function(){
                var children = this.getChildren();
                var rootNode = this.domNode;

                var maxCols = this.cols * (this.showLabels ? 2 : 1);
                var numCols = 0;
                var labelRow;
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
                        colspan = this.showLabels ?
                        Math.min(maxCols - 1, colspan * 2 -1): Math.min(maxCols, colspan);
                    }

                    // Create a new row if we need one
                    if(!labelRow || !childRow || (numCols + colspan - 1 + (this.showLabels ? 1 : 0)>= maxCols)) {
                        numCols = 0;
                        var horiz = this.orientation === "horiz";
                        var firstRow = !labelRow;
                        labelRow = domConstruct.create("div", {
                            "class": "row" + (!horiz? " labelRow" : "") + (firstRow ? " first-row":"")
                        }, rootNode);
                        childRow = horiz ? labelRow : domConstruct.create("div", {
                            "class": "row valueRow"
                        }, rootNode);
                    }
                    var labelCell;

                    // If labels should be visible, add them
                    if(this.showLabels) {
                        labelCell = domConstruct.create("div", {
                            "class": "cell " +(!child.spanLabel?"labelCell" + (child.labelClass?" "+child.labelClass:""):("valueCell" + (child.valueClass?" "+child.valueClass:"")))
                        }, labelRow);
                        this.addCustomClass(labelCell, "labelCell", index);

                        // If the widget should take up both the label and value,
                        // then just set the class on it.
                        if(!child.spanLabel) {
                            var labelProps = {
                                "for": child.get("id")
                            };
                            var label = domConstruct.create("label", labelProps, labelCell);
                            if(this.labelClass) {
                                domClass.add(labelCell,this.labelClass);
                            }
                            label.innerHTML = child.get("colLabel") || child.get("label") || child.get("title");
                        }
                    }
                    var childCell;
                    if(child.spanLabel && labelCell) {
                        childCell = labelCell;
                    } else {
                        childCell = domConstruct.create("div", {
                            "class" : "cell valueCell" + (child.valueClass?" "+child.valueClass:"")
                        }, childRow);
                    }
                    // Add the widget cell's custom class, if one exists.
                    this.addCustomClass(childCell, "valueCell", index);

                    
                    child.placeAt(childCell);
                    
                    numCols += colspan + (this.showLabels ? 1 : 0);
                },this);
                if (childRow){
                    domClass.add(childRow,"last-row");
                }
            },
            addCustomClass:  function (node, type, count) {
                if(this.customClass) {
                    var clazz = this.customClass+ "-" + (type || node.tagName.toLowerCase());
                    domClass.add(node, clazz);
                    if(arguments.length > 2) {
                        domClass.add(node, clazz + "-" + count);
                    }
                }
            }
        });

        return declare([_Control],
        {
            controlClass : "gridpanel",
            createWidget: function (params) {
                return new GridLayout(d_lang.mixin(params,{
                    cols : this.cols || 1,
                    showLabels : ct_lang.chk(this.showLabels, true),
                    labelClass : this.labelClass || "label",
                    // horiz | vert
                    orientation : this.labelOrientation || "horiz",
                    spacing : 0
                }));
            }
        });
    });