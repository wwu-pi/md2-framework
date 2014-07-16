define(["dojo/_base/lang","dojo/_base/declare","./_Control","dijit/layout/TabContainer","ct/_lang"],
    function(d_lang,declare,_Control,TabContainer,ct_lang){
        TabContainer = declare([TabContainer],
        {
            startup : function(){
                this.inherited(arguments);
                var selected = this.selectedChildWidget;
                if (selected){
                    this.selectedChildWidget = undefined;
                    this.selectChild(selected);
                }
            },
            addChild : function(w){
                w.title = w.title || w.label;
                this.inherited(arguments);
            }
        });

        return declare([_Control],
        {
            controlClass : "tabpanel",
            createWidget: function (params) {
                return new TabContainer(d_lang.mixin(params,{
                    title : params.label,
                    tabStrip: ct_lang.chk(this.tabStrip,false),
                    nested: ct_lang.chk(this.nested,false),
                    useMenu: ct_lang.chk(this.useMenu,true)
                }));
            }
        });
    });