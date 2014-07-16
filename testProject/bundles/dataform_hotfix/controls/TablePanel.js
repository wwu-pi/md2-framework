define(["dojo/_base/lang","dojo/_base/declare","./_Control","dojox/layout/TableContainer"],
    function(d_lang,declare,_Control,TableContainer){

        return declare([_Control],
        {
            controlClass : "tablepanel",
            createWidget: function (params) {
                return new TableContainer(d_lang.mixin(params,{
                    customClass : this.customClass || "",
                    cols : this.cols || 1,
                    showLabels : this.showLabels || false,
                    labelWidth : this.labelWidth || 100,
                    // horiz | vert
                    orientation : this.labelOrientation || "horiz",
                    spacing : 0
                }));
            }
        });
    });