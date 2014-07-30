define([
    "dojo/_base/declare", "dojo/_base/array"
],
function(declare, array) {
    return declare([], {
        /**
         * Array of actions that have to be executed on event
         */
        _actions: null,
        
        /**
         * Reference to the event handler of the actual
         */
        _eventHandler: null,
        
        constructor: function() {
            this._actions = [];
        },
        
        /**
         * Binds an action to this event.
         * 
         * @param {Action} action - The action that should be bound to this event.
         */
        registerAction: function(action) {
            // add action if not already contained
            var hasAction = array.some(this._actions, function(a) {
                return a.equals(action);
            });
            if(!hasAction) {
                this._actions.push(action);
            }
            
            // set event if this was the first action registered
            if (!this._eventHandler && this._actions.length === 1) {
                var eventHandler = this._setEvent();
                this._eventHandler = eventHandler;
            }
        },
        
        /**
         * Unbinds an action from this event. If the action is not bound to this event, nothing happens.
         * 
         * @param {Action} action - Action to be unbound from this event.
         */
        unregisterAction: function(action) {
            // remove action if contained
            var indexOf = -1;
            array.forEach(this._actions, function(a, idx) {
                if (a.equals(action)) {
                    indexOf = idx;
                }
            });
            if (indexOf !== -1) {
                this._actions.splice(indexOf, 1);
            }
            
            // remove event if this was the last action bound
            if (this._eventHandler && !this._actions.length) {
                this._unsetEvent(this._eventHandler);
                this._eventHandler = null;
            }
        },
        
        /**
         * Implement in concrete class.
         *
         * @returns {undefined}
         */
        _setEvent: function() {
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
            if (eventHandler !== null) {
                console && console.error("_unsetEvent has to be implemented!");
            }
        },
        
        /**
         * Callback function for the actual event (as defined in _setEvent).
         * Executes all actions bound to the current event.
         */
        _onEvent: function() {
            array.forEach(this._actions, function(action) {
                action.execute();
            });
        }
    });
});
