define([
    "dojo/_base/declare", "dojo/_base/array", "ct/Hash"
],
function(declare, array, Hash) {
    return declare([], {
        /**
         * Object that stores the names of all widgets to an array of actions that have to be executed on event.
         */
        _widgetToActionsMapping: null,
        
        /**
         * Reference to the event handler of the actual widgets.
         */
        _widgetToEventHandlerMapping: null,
        
        _appId: null,
        
        constructor: function(appId) {
            this._widgetToActionsMapping = new Hash();
            this._widgetToEventHandlerMapping = new Hash();
            this._appId = appId;
        },
        
        /**
         * Binds an action to a specific widget event.
         * 
         * @param {WidgetWrapper} widget - Widget wrapper that contains a Dijit widget.
         * @param {Action} action - The action that should be bound to this event.
         */
        registerAction: function(widget, action) {
            
            if (!widget) {
                return;
            }
            
            var widgetId = widget.getId();
            
            // check whether there are already actions bound to this widget
            if (!this._widgetToActionsMapping.contains(widgetId)) {
                this._widgetToActionsMapping.set(widgetId, []);
            }
            
            var actions = this._widgetToActionsMapping.get(widgetId);
            
            // add action if not already contained
            var hasAction = array.some(actions, function(a) {
                return a.equals(action);
            });
            if(!hasAction) {
                actions.push(action);
            }
            
            // set event if this was the first action registered
            if (!this._widgetToEventHandlerMapping.contains(widgetId) && actions.length === 1) {
                var eventHandler = this._setEvent(widget);
                if(eventHandler) {
                    this._widgetToEventHandlerMapping.set(widgetId, eventHandler);
                }
            }
        },
        
        /**
         * Unbinds an action from this event. If the action is not bound to this event, nothing happens.
         * 
         * @param {WidgetWrapper} widget - Widget wrapper that contains a Dijit widget.
         * @param {Action} action - Action to be unbound from this event.
         */
        unregisterAction: function(widget, action) {
            
            if (!widget) {
                return;
            }
            
            var widgetId = widget.getId();
            
            if (!this._widgetToActionsMapping.contains(widgetId)) {
                return;
            }
            
            var actions = this._widgetToActionsMapping.get(widgetId);
            
            // remove action if contained
            var indexOf = -1;
            array.forEach(actions, function(a, idx) {
                if (a.equals(action)) {
                    indexOf = idx;
                }
            });
            if (indexOf !== -1) {
                actions.splice(indexOf, 1);
            }
            
            // remove event if this was the last action bound
            if (this._widgetToEventHandlerMapping.contains(widgetId) && !actions.length) {
                this._unsetEvent(this._widgetToEventHandlerMapping.get(widgetId));
                this._widgetToEventHandlerMapping.remove(widgetId);
            }
        },
        
        /**
         * Implement in concrete class.
         *
         * @returns {undefined}
         */
        _setEvent: function(widget) {
            // To be implemented in concrete class.
            // Has to call _onEvent when event fires.
            // (optional) Has to return a reference to the actual event handler so that the event can be unbound.
            
            console && console.error("_setEvent has to be implemented!");
        },
        
        /**
         * Implement in concrete class.
         * 
         * @param eventHandler - The event handler returned by _setEvent (might be null)
         */
        _unsetEvent: function(eventHandler) {
            // (optional) if event handlers are tracked.
            if (eventHandler) {
                console && console.error("_unsetEvent has to be implemented!");
            }
        },
        
        /**
         * Callback function for the actual event (as defined in _setEvent).
         * Executes all actions bound to the current event.
         * 
         * @param {FormControl} formControl
         */
        _onEvent: function(widget) {
            
            var widgetId = widget.getId();
            
            if (!this._widgetToActionsMapping.contains(widgetId)) {
                return;
            }
            
            var actions = this._widgetToActionsMapping.get(widgetId);
            array.forEach(actions, function(action) {
                action.execute();
            });
        }
    });
});
