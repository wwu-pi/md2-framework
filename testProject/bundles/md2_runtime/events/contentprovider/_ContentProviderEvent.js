define([
    "dojo/_base/declare", "dojo/_base/array", "ct/Hash"
],
function(declare, array, Hash) {
    return declare([], {
        /**
         * Object that stores the names of all contentprovider$attribute combinations to
         * an array of actions that have to be executed on event.
         */
        _contentProviderToActionsMapping: null,
        
        /**
         * Reference to the event handler of the actual contentprovider$attribute combinations.
         */
        _contentProviderToEventHandlerMapping: null,
        
        _appId: null,
        
        constructor: function(appId) {
            this._contentProviderToActionsMapping = new Hash();
            this._contentProviderToEventHandlerMapping = new Hash();
            this._appId = appId;
        },
        
        /**
         * Binds an action to a specific content provider event.
         * 
         * @param {ContentProvider} contentProvider - Content provider.
         * @param {String} attribute - Attribute as a fully qualified name, separated by dots.
         * @param {Action} action - The action that should be bound to this event.
         */
        registerAction: function(contentProvider, attribute, action) {
            
            var id = contentProvider.getName() + "$" + attribute;
            
            // check whether there are already actions bound to this widget
            if (!this._contentProviderToActionsMapping.contains(id)) {
                this._contentProviderToActionsMapping.set(id, []);
            }
            
            var actions = this._contentProviderToActionsMapping.get(id);
            
            // add action if not already contained
            var hasAction = array.some(actions, function(a) {
                return a.equals(action);
            });
            if(!hasAction) {
                actions.push(action);
            }
            
            // set event if this was the first action registered
            if (!this._contentProviderToEventHandlerMapping.contains(id) && actions.length === 1) {
                var eventHandler = this._setEvent(contentProvider, attribute);
                if(eventHandler) {
                    this._contentProviderToEventHandlerMapping.set(id, eventHandler);
                }
            }
        },
        
        /**
         * Unbinds an action from this event. If the action is not bound to this event, nothing happens.
         * 
         * @param {ContentProvider} contentProvider - Content provider.
         * @param {String} attribute - Attribute as a fully qualified name, separated by dots.
         * @param {Action} action - Action to be unbound from this event.
         */
        unregisterAction: function(contentProvider, attribute, action) {
            
            var id = contentProvider.getName() + "$" + attribute;
            
            if (!this._contentProviderToActionsMapping.contains(id)) {
                return;
            }
            
            var actions = this._contentProviderToActionsMapping.get(id);
            
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
            if (this._contentProviderToEventHandlerMapping.contains(id) && !actions.length) {
                this._unsetEvent(this._contentProviderToEventHandlerMapping.get(id));
                this._contentProviderToEventHandlerMapping.remove(id);
            }
        },
        
        /**
         * Implement in concrete class.
         * 
         * @param {ContentProvider} contentProvider - Content provider.
         * @param {String} attribute - Attribute as a fully qualified name, separated by dots.
         * @returns {undefined}
         */
        _setEvent: function(contentProvider, attribute) {
            // To be implemented in concrete class.
            // Has to call _onEvent when event fires.
            // (optional) Has to return a reference to the actual event handler so that the event can be unbound.
            
            console && console.error("_setEvent has to be implemented!");
        },
        
        /**
         * Implement in concrete class.
         * 
         * @param eventHandler - The event handler returned by _setEvent (might be null).
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
         * @param {ContentProvider} contentProvider
         * @param {String} attribute
         */
        _onEvent: function(contentProvider, attribute) {
            var id = contentProvider.getName() + "$" + attribute;
            if (!this._contentProviderToActionsMapping.contains(id)) {
                return;
            }
            var actions = this._contentProviderToActionsMapping.get(id);
            array.forEach(actions, function(action) {
                action.execute();
            });
        }
    });
});
