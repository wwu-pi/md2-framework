define(["dojo/_base/lang", "dojo/_base/declare", "dojo/_base/array", "ct/_lang", "./controls/FormControls", "ct/Exception"],
        function(d_lang, declare, d_array, ct_lang, FormControls, Exception) {
            return declare([], {
                /**
                 * The json definiton of the data form.
                 * @property
                 */
                definition: {},
                // shared default control factory
                controlFactory: new FormControls(),
                constructor: function(opts) {
                    this.definition = opts.definition;
                    this.controlFactory = opts.controlFactory || this.controlFactory;
                },
                /**
                 * Interprets the json definition and creates a new root dataform control.
                 */
                build: function() {
                    var definition = this.definition;
                    return this._interpret(definition);
                },
                _interpret: function(elem, parent) {
                    try {
                        var type = this._getType(elem);
                        var title = this._getTitle(elem);
                        var widgetParams = this._getWidgetParams(elem);
                        if (title) {
                            widgetParams.title = title;
                        }
                        var control = this.controlFactory.createFormControl(type, widgetParams);

                        var children = this._getChildDefinitions(elem);
                        d_array.forEach(children, function(childDefinition) {
                            this._interpret(childDefinition, control);
                        }, this);

                        var widgetSizeConstrains = this._getWidgetSizeConstrains(elem);
                        if (parent) {
                            parent.addControl(control, widgetSizeConstrains);
                        } else if (control.resize) {
                            control.resize(widgetSizeConstrains);
                        }
                        return control;
                    } catch (e) {
                        throw Exception.wrap(e);
                    }
                },
                _getTitle: function(elem) {
                    return elem.Caption || elem.Title || elem.title || "";
                },
                _getType: function(elem) {
                    var type = elem.Type || elem.type || elem.__type;
                    if (type) {
                        // e.g. : "Label:#Conterra.Osiris.LinfosBusiness.Structure.Forms.Design"
                        type = type.split(":")[0].toLowerCase();
                        // results e.g. in "label"
                        type = type.replace(/field$/, "");
                        return type;
                    }
                    if (elem.FormElements || elem.formelements || elem.children) {
                        return "panel";
                    }
                    throw Exception.illegalArgumentError("JsonFactory: can not resolve widget type from '" + elem + "'");
                },
                _getChildDefinitions: function(elem) {
                    return elem.FormElements || elem.formelements || elem.children || elem.Pages || elem.pages || [];
                },
                _getWidgetSizeConstrains: function(elem) {
                    var constrains = {};
                    var position = elem.Position || elem.position || elem.Size || elem.size;
                    if (position) {
                        constrains.l = position.Left || position.left || position.l || 0;
                        constrains.t = position.Top || position.top || position.t || 0;
                    }
                    var size = elem.Size || elem.size;
                    if (size) {
                        constrains.w = position.Width || position.width || position.w || undefined;
                        constrains.h = position.Height || position.height || position.h || undefined;
                    }
                    return constrains;
                },
                _nonConstructorProperties: (function() {
                    var handledProps = [];
                    handledProps.push("Caption");
                    handledProps.push("Title");
                    handledProps.push("title");
                    handledProps.push("Type");
                    handledProps.push("type");
                    handledProps.push("__type");
                    handledProps.push("Pages");
                    handledProps.push("pages");
                    handledProps.push("pages");
                    handledProps.push("FormElements");
                    handledProps.push("formelements");
                    handledProps.push("children");
                    handledProps.push("Position");
                    handledProps.push("position");
                    handledProps.push("Size");
                    handledProps.push("size");
                    return handledProps;
                })(),
                _getWidgetParams: function(elem) {
                    // copys all properties from the element, but ignores some well known
                    var params = ct_lang.copyAllProps({}, elem, this._nonConstructorProperties);
                    if (params.options && !params.options._no_mixin) {
                        var opts = params.options;
                        delete params.options;
                        d_lang.mixin(params, opts);
                    }
                    return params;
                }
            });
        });