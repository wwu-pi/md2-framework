define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/topic"
],
function(declare, lang, array, topic) {
    return declare([], {
        
        _customActions: null,
        
        _refs: null,
        
        _eventRegistry: {},
        
        
        /////////////////////////////////////////////////////////////////////
        // Set application specific custom actions
        /////////////////////////////////////////////////////////////////////
        
        constructor: function(customActions, references) {
            this._refs = references;
            this._customActions = customActions;
            customActions.$ = this;
        },
        
        run: function(actionName) {
            var scope = actionName.split("$.")[1] ? this : this._customActions;
            var func = scope[actionName];
            if(func && lang.isFunction(func)) {
                func.apply(scope, Array.prototype.slice.call(arguments, 1));
            } else {
                console && console.error("MD2ActionExecutor: '" + actionName + "' is not defined or is not a function!");
            }
        },
        
        
        /////////////////////////////////////////////////////////////////////
        // Definition of all predefined actions that are supported by MD2
        /////////////////////////////////////////////////////////////////////
        
        mapAction: function(dataFormField, contentProviderName, entityAttribute) {
            this._refs.dataMapper.map(dataFormField, contentProviderName, entityAttribute);
        },
        
        unmapAction: function(dataFormField, contentProviderName, entityAttribute) {
            this._refs.dataMapper.unmap(dataFormField, contentProviderName, entityAttribute);
        },
        
        bindValidatorAction: function(dataFormField, validatorType, validatorConfiguration) {
            var mapping = this._refs.dataMapper.getMapping(dataFormField);
            if(!mapping.hasFormControl) {
                console && console.error("MD2ActionExecutor: No form control mapped to '" + dataFormField + "'!");
                return;
            }
            var widget = mapping.formControl.widget;
            var c = validatorConfiguration || {};
            
            switch(validatorType) {
                case "regex":
                    widget.pattern = c.pattern;
                    break;
                case "notNull":
                    widget.required = true;
                    break;
                case "numberRange":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.min = c.min;
                    widget.constraints.max = c.max;
                    break;
                case "stringRange":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.minLength = c.minLength;
                    widget.constraints.maxLength = c.maxLength;
                    break;
                case "isInt":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isIntegerCheck = true;
                    break;
                case "isNumber":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isNumberCheck = true;
                    break;
                case "isDate":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isDateCheck = true;
                    break;
            }
        },
        
        unbindValidatorAction: function(dataFormField, validatorType) {
            var mapping = this._refs.dataMapper.getMapping(dataFormField);
            if(!mapping.hasFormControl) {
                console && console.error("MD2ActionExecutor: No form control mapped to '" + dataFormField + "'!");
                return;
            }
            var widget = mapping.formControl.widget;
            
            switch(validatorType) {
                case "regex":
                    widget.pattern = /.*/i;
                    break;
                case "notNull":
                    widget.required = false;
                    break;
                case "numberRange":
                    widget.constraints = widget.constraints || {};
                    delete widget.constraints.min;
                    delete widget.constraints.max;
                    break;
                case "stringRange":
                    widget.constraints = widget.constraints || {};
                    delete widget.constraints.minLength;
                    delete widget.constraints.maxLength;
                    break;
                case "isInt":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isIntegerCheck = false;
                    break;
                case "isNumber":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isNumberCheck = false;
                    break;
                case "isDate":
                    widget.constraints = widget.constraints || {};
                    widget.constraints.isDateCheck = false;
                    break;
            }
        },
        
        bindEventAction: function(event, dataFormField, executeAction, actionParameters) {
            var identifier = [event, dataFormField, executeAction].concat(actionParameters).join("$");
            var mapping = dataFormField ? this._refs.dataMapper.getMapping(dataFormField) : null;
            var ref;
            
            if(this._eventRegistry[identifier]) {
                return;
            }
            
            if(dataFormField && !mapping.hasFormControl) {
                console && console.error("MD2ActionExecutor: No form control mapped to '" + dataFormField + "'!");
                return;
            }
            
            switch(event) {
                case "click":
                    ref = mapping.formControl.widget.on("click", lang.hitch(this, function() {
                        this.run.apply(this, [executeAction].concat(actionParameters));
                    }));
                    break;
                case "onLeftSwipe":
                    // TODO
                    break;
                case "onRightSwipe":
                    // TODO
                    break;
                case "onWrongValidation":
                    // TODO
                    break;
                case "onConnectionLost":
                    ref = topic.subscribe("md2/connectionEvent/" + event, lang.hitch(this, function() {
                        this.run.apply(this, [executeAction].concat(actionParameters));
                    }));
                    break;
                default:
                    // custom event
                    ref = topic.subscribe("md2/customEvent/" + event, lang.hitch(this, function() {
                        this.run.apply(this, [executeAction].concat(actionParameters));
                    }));
            }
            
            this._eventRegistry[identifier] = ref;
        },
        
        unbindEventAction: function(event, dataFormField, executeAction, actionParameters) {
            var identifier = [event, dataFormField, executeAction].concat(actionParameters).join("$");
            if(!this._eventRegistry[identifier]) {
                return;
            }
            this._eventRegistry[identifier].remove();
            delete this._eventRegistry[identifier];
        },
        
        gotoViewAction: function(viewName) {
            
        },
        
        assignObjectAction: function(contentProviderNameUse, contentProviderNameFor, entityAttribute) {
            
        },
        
        newObjectAction: function(contentProviderName) {
            
        },
        
        dataAction: function(contentProviderName, action) {
            if(array.indexOf(["load", "save", "remove"], action) < 0) {
                console && console.error("MD2ActionExecutor: Unsupported data action '" + action + "'!");
                return;
            }
            this._refs.eventHandler.registerDataEvent();
            var contentProvider = this._refs.contentProviderRegistry.getContentProvider(contentProviderName);
            contentProvider && contentProvider[action]();
        },
        
        gpsUpdateAction: function(stringTemplate, contentProviderName, entityAttribute) {
            // can be used to get Feedback from the map!
        },
        
        goToWorkflowStepAction: function(workflowName, stepName) {
            
        },
        
        setActiveWorkflowAction: function(workflowName) {
            
        },
        
        nextStepAction: function() {
            
        },
        
        previousStepAction: function() {
            
        }
        
    });
});
