define([
    "dojo/_base/lang",
    "dojo/_base/declare",
    "dojo/dom-construct",
    "ct/_lang",
    "./_Control",
    "dijit/form/HorizontalSlider",
    "dijit/form/VerticalSlider",
    "dijit/form/HorizontalRuleLabels",
    "dijit/form/VerticalRuleLabels",
    "dijit/form/HorizontalRule",
    "dijit/form/VerticalRule"],
    function(d_lang, declare, domConstruct, ct_lang, _Control, HorizontalSlider, VerticalSlider, HorizontalRuleLabels, VerticalRuleLabels, HorizontalRule, VerticalRule) {
        /**
         * @fileOverview This is a widget for displaying a slider, horizontal or vertical
         */
        return declare([_Control],
            {
                controlClass : "slider",

                constructor: function() {
                },

                createWidget : function (params) {
                    var slider = this._createSliderWidget(params);
                    var ruleLabels, rule;
                    if (this.showRuleLabels) {
                        ruleLabels = this._createRuleLabels();
                    }
                    if (this.showRule) {
                        rule = this._createRule();
                    }

                    if (this.vertical) {
                        if (rule) {
                            rule.placeAt(slider.containerNode);
                        }
                        if (ruleLabels) {
                            ruleLabels.placeAt(slider.containerNode);
                        }
                    } else {
                        if (rule) {
                            rule.placeAt(slider.containerNode);
                        }
                        if (ruleLabels) {
                            ruleLabels.placeAt(slider.containerNode);
                        }
                    }

                    slider.startup();
                    if (rule) {
                        rule.startup();
                    }
                    if (ruleLabels) {
                        ruleLabels.startup();
                    }
                    return slider;
                },

                _createRule: function(node) {
                    var Rule = this.vertical ? VerticalRule : HorizontalRule;
                    var rule = new Rule({
                        container: this.vertical ? "rightDecoration" : "bottomDecoration",
                        count: this.rulesCount !== undefined ? this.rulesCount : 3,
                        style: this.rulesStyle || (this.vertical ? "width: 5px; margin: 0px;" : "height: 5px; margin: 2px 0;"),
                        constraints: this.ruleConstraints
                    }, node);
                    return rule;
                },

                _createRuleLabels: function(node) {
                    var RuleLabels = this.vertical ? VerticalRuleLabels : HorizontalRuleLabels;
                    var ruleLabels = new RuleLabels({
                        container: this.vertical ? "rightDecoration" : "bottomDecoration",
                        style: this.ruleLabelsStyle || (this.vertical ? "margin: 0px 15px 0px 0px;" : "margin: 0;"),
                        count: this.ruleLabelsCount !== undefined ? this.ruleLabelsCount : 3,
                        numericMargin: this.ruleLabelsNumericMargin === undefined ? 1 : this.ruleLabelsNumericMargin,
                        constraints: this.ruleLabelsConstraints,
                        labels: this.ruleLabels || []
                    }, node);
                    return ruleLabels;
                },

                _createSliderWidget: function(params) {
                    var Slider = this.vertical ? VerticalSlider : HorizontalSlider;
                    this.min = ct_lang.chk(this.min, 0);

                    return new Slider(d_lang.mixin(params,{
                        required : this.required,
                        minimum : this.min,
                        maximum : ct_lang.chk(this.max, 100),
                        showButtons : ct_lang.chk(this.showButtons, true),
                        clickSelect : ct_lang.chk(this.clickSelect, true)
                    }));
                },

                clearBinding : function(){
                    this._updateValue(this.field);
                },
                refreshBinding : function(){
                    var binding = this.dataBinding;
                    var field = this.field;
                    var widget = this.widget;
                    this.connectP("binding",binding,field,"_updateValue");
                    this.connectP("binding",widget,"value","_storeValue");
                    this._updateValue(field, undefined, binding.get(field));
                },
                _updateValue : function(prop, oldVal, newVal){
                    this.widget.set("value",newVal||this.min||0);
                },
                _storeValue : function(prop, oldVal, newVal){
                    this.dataBinding.set(this.field,newVal||this.min||0);
                }
            });
    });