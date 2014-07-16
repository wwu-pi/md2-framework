define(["dojo/_base/lang","dojo/_base/declare","./_Control","dijit/layout/ContentPane"],
    function(d_lang,declare,_Control,ContentPane) {
        var checkIfSingleChild = function(){
            if(this.getChildren().length==1){
                ContentPane.prototype._checkIfSingleChild.call(this);
            }
        };
        /**
        * @fileOverview This is a panel of a formular.
        */
        return declare([_Control],
        {
            controlClass : "panel",
            createWidget: function (params) {
                return new ContentPane(d_lang.mixin(params,{
                    // set title from label attribute
                    title : params.label,
                    // disable dom content parsing
                    parseOnLoad: false,
                    // allow html loading in panel
                    href : this.url || "",
                    _checkIfSingleChild : checkIfSingleChild
                }));
            }
        });
    });