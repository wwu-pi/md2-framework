define(["dojo/_base/declare","dojo/_base/lang","./_Control","dijit/layout/BorderContainer","ct/_lang"],
    function(declare,d_lang,_Control,BorderContainer,ct_lang){

        return declare([_Control],
        {
            controlClass : "borderpanel",
            createWidget: function (params) {
                return new BorderContainer(d_lang.mixin(params,{
                    gutters: ct_lang.chk(this.gutters,false),
                    // headline | sidebar
                    design: ct_lang.chk(this.design,"headline"),
                    splitter: ct_lang.chk(this.splitter,"false"),
                    liveSplitters : ct_lang.chk(this.liveSplitters,"true")
                }));
            }
        });
    });