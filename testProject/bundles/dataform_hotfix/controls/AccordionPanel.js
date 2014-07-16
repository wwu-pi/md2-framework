define(["dojo/_base/declare","./_Control","dijit/layout/AccordionContainer"],
    function(declare,_Control,AccordionContainer){

        return declare([_Control],
        {
            controlClass : "accordionpanel",
            createWidget: function (params) {
                return new AccordionContainer(params);
            }
        });
    });