define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "./simpleactions/ContentProviderOperationAction",
    "./simpleactions/ContentProviderResetAction",
    "./simpleactions/EnableAction",
    "./simpleactions/DisableAction",
    "./simpleactions/DisplayMessageAction",
    "./simpleactions/GotoViewAction"
], function(
    declare,
    array,
    ContentProviderOperationAction,
    ContentProviderResetAction,
    EnableAction,
    DisableAction,
    DisplayMessageAction,
    GotoViewAction
) {
    
    return declare([], {
        
        _references: null,
        
        _customActions: null,
        
        constructor: function(customActions, $) {
            this._references = $;
            this._customActions = customActions;
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
                throw new Error("[ActionFactory] No CustomAction with name '" + name + "' found!");
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
