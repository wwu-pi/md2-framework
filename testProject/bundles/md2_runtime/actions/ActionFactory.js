define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "./simpleactions/ContentProviderOperationAction",
    "./simpleactions/ContentProviderResetAction",
    "./simpleactions/EnableAction",
    "./simpleactions/DisableAction",
    "./simpleactions/DisplayMessageAction",
    "./simpleactions/GotoViewAction",
    "../datatypes/TypeFactory"
], function(
    declare,
    lang,
    array,
    ContentProviderOperationAction,
    ContentProviderResetAction,
    EnableAction,
    DisableAction,
    DisplayMessageAction,
    GotoViewAction,
    TypeFactory
) {
    
    return declare([], {
        
        _references: {
            dataMapper: null,
            eventRegistry: null,
            contentProviderRegistry: null,
            actionFactory: null,
            viewManager: null,
            widgetRegistry: null,
            dataEventHandler: null,
            notificationService: null,
            create: null
        },
        
        _customActions: undefined,
        
        constructor: function(customActions, references) {
            lang.mixin(this._references, references);
            this._customActions = customActions;
            this._references.actionFactory = this;
            this._references.create = TypeFactory.create;
        },
        
        getCustomAction: function(name) {
            var returnAction;
            array.some(this._customActions, function(customAction) {
                if (customAction._actionSignature === name) {
                    customAction.$ = this._references;
                    returnAction = customAction;
                    return false;
                }
            }, this);
            
            if (returnAction) {
                return returnAction;
            } else {
                console && console.error("[ActionFactory] No CustomAction with name '" + name + "' found!");
            }
        },
        
        getContentProviderOperationAction: function(contentProvider, operation) {
            var action = new ContentProviderOperationAction(contentProvider, operation);
            action.$ = this._references;
            return action;
        },
        
        getContentProviderResetAction: function(contentProvider) {
            var action = new ContentProviderResetAction(contentProvider);
            action.$ = this._references;
            return action;
        },
        
        getEnableAction: function(widget) {
            var action = new EnableAction(widget);
            action.$ = this._references;
            return action;
        },
        
        getDisableAction: function(widget) {
            var action = new DisableAction(widget);
            action.$ = this._references;
            return action;
        },
        
        getDisplayMessageAction: function(signature, messageCallback) {
            var action = new DisplayMessageAction(signature, messageCallback);
            action.$ = this._references;
            return action;
        },
        
        getGotoViewAction: function(viewName) {
            var action = new GotoViewAction(viewName);
            action.$ = this._references;
            return action;
        }
        
    });
});
