define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "dojo/string",
    "dojo/topic",
    "../datatypes/_Type",
    "ct/Hash"
],

/**
 * ContentProviders hold an instance of the actual object from the backend and provide an interface
 * to access the local copies of the object(s), save all objects hold by the ContentProvider to the
 * web service/database, load specified objects from the web service/database and to remove the managed
 * objects from the web service/database.
 * 
 * The ContentProvider might access fields in the dataForm to configure its filter.
 */
function(declare, lang, array, string, topic, _Type, Hash) {
    
    return declare([], {
        
        /**
         * The actual entity instance or collection of entities that is managed by this ContentProvider.
         * Array of entities.
         */
        _content: null,
        
        /**
         * Stores whether this is a 'many' contentent provider or a content provider that can only hold a
         * single instance of the entity.
         */
        _isManyProvider: false,
        
        /**
         * Reference on the store that is capable of handling the objects managed by this ContentProvider.
         */
        _store: null,
        
        /**
         * A hash that contains all observed attributes along with their current value. If an attribute value
         * is set, it is compared with the value in this hash. In case the attribute set is an entity, also all
         * child attributes are resolved and checked. If a value of any of the registered attributes changed,
         * an onChange event is fired.
         * 
         * {
         *   qualifiedAttrName: {
         *     value: VALUE,
         *     numberOfObservers: INT
         *   },
         *   ...
         * }
         */
        _observedAttributes: null,
        
        /**
         * Reference to a builder function for filters. The function returns a
         * ComplexQuery object that describes the load filter for this content provider.
         */
        _filter: null,
        
        /**
         * Unique name that identifies this content provider. For example, this is required when the
         * content provider publishes messages to the dojo topic to identify itself.
         */
        _name: null,
        
        /**
         * Identifier of the topic this content provider publishes to for data updates.
         */
        _topicAction: "md2/contentProvider/dataAction/${appId}",
        
        /**
         * Identifier of the topic this content provider publishes to for onChange events.
         */
        _topicOnChange: "md2/contentProvider/onChange/${appId}",
        
        /**
         * Debug messages
         */
        _DEBUG_MSG: {
            nameParamErr: "MD2ContentProvider: The required parameter 'name' is not passed to the constructor!",
            storeParamErr: "MD2ContentProvider: The required parameter 'store' is not passed to the constructor!"
        },
        
        /**
         * The filter object has to have the following format:
         * filter: {
         *   query: <ComplexQuery with placeHolders for dataFormFields>,
         *   count: "first"|"all",
         *   dataMapper: <reference to the used data mapper>
         * }
         * 
         * @param {string} name
         * @param {string} appId
         * @param {MD2Store} store
         * @param {boolean} isManyProvider
         * @param {Object} filter
         */
        constructor: function(name, appId, store, isManyProvider, filter) {
            !name && window.console && window.console.error(this._DEBUG_MSG["nameParamErr"]);
            !store && window.console && window.console.error(this._DEBUG_MSG["storeParamErr"]);
            this._name = name;
            
            this._topicAction = string.substitute(this._topicAction, {appId: appId});
            this._topicOnChange = string.substitute(this._topicOnChange, {appId: appId});
            
            this._store = store;
            this._content = [];
            this._observedAttributes = new Hash();
            this._filter = filter;
            this._isManyProvider = isManyProvider || false;
            this.reset();
        },
        
        getContent: function() {
            return this._isManyProvider ? this._content : this._content[0];
        },
        
        /**
         * @param {_Entity} content - Entity or array of entities to set.
         */
        setContent: function(content) {
            content = lang.isArray(content) ? content : [content];
            var entityFactory = this._store.entityFactory.create();
            var clonedContent = [];
            
            // recursively clone entity
            array.forEach(content, function(entity) {
                var newEntity = entity ? entity.clone() : entityFactory;
                clonedContent.push(newEntity);
            });
            
            this._setContent(clonedContent);
        },
        
        _setContent: function(content) {
            this._content = content;
            this._fireAllOnChanges();
        },
        
        registerObservedOnChange: function(attribute) {
            if (!this._observedAttributes.contains(attribute)) {
                this._observedAttributes.set(attribute, {
                    value: this.getValue(attribute),
                    numberOfObservers: 0
                });
            }
            this._observedAttributes.get(attribute).numberOfObservers++;
            
            // handler to unregister attribute again
            var unregisterObservedOnChange = this.unregisterObservedOnChange;
            return {
                unregister: function() {
                    unregisterObservedOnChange(attribute);
                }
            };
        },
        
        unregisterObservedOnChange: function(attribute) {
            if (!this._observedAttributes.contains(attribute)) {
                return;
            }
            var entry = this._observedAttributes.get(attribute);
            entry.numberOfObservers--;
            
            if (entry.numberOfObservers === 0) {
                this._observedAttributes.remove(attribute);
            }
        },
        
        /**
         * Fires on change event for all changed attributes and updates the current values
         * of the observed elements.
         */
        _fireAllOnChanges: function(qualifiedAttrName) {
            
            var isAnyValueChanged = false;
            
            // It was a setValue event. Distinguish the two cases:
            // 1. Value was set
            // 2. Entity was set
            if (qualifiedAttrName) {
            
                // Case 1: Value was set => there cannot be any child attributes
                var val = this.getValue(qualifiedAttrName);
                if (val && val.isInstanceOf(_Type)) {
                    var attr = this._observedAttributes.get(qualifiedAttrName);
                    if (attr) {
                        var oldValue = attr.value;
                        if (!val.equals(oldValue)) {
                            isAnyValueChanged = true;
                            topic.publish(this._topicOnChange, this, qualifiedAttrName, val, oldValue);
                        }
                    }    
                }
            }
            
            // Case 2: Entity was set or the entire content provider was updated => reset / load / setContent
            else {
                this._observedAttributes.forEach(function(value, key) {
                    
                    // If an attribute is set, only resolve its child attributes.
                    // Otherwise all attributes (content provider reset).
                    var isResolve = qualifiedAttrName ? key.indexOf(qualifiedAttrName) === 0 : true;
                    
                    if (isResolve) {
                        var newValue = this.getValue(key);
                        if (!newValue && newValue !== value || !newValue.equals(value)) {
                            var attr = this._observedAttributes.get(key);
                            var oldValue = attr.value;
                            attr.value = newValue;
                            isAnyValueChanged = true;
                            topic.publish(this._topicOnChange, this, key, newValue, oldValue);
                        }
                    }
                }, this);
            }
            
            // Inform all listeners that listen to any events along the path.
            // All childs are already informed in case 2.
            if (isAnyValueChanged) {
                if (qualifiedAttrName) {
                    var pathSegments = qualifiedAttrName.split(".").pop();
                    var currentPath = "";
                    array.forEach(pathSegments, function(pathSegment, idx) {
                        currentPath += (idx !== 0 ? "." : "") + pathSegment;
                        topic.publish(this._topicOnChange, this, currentPath, null, null);
                    }, this);
                }
                
                // Fire event for content provider.
                topic.publish(this._topicOnChange, this, "*", null, null);
            }
        },
        
        /**
         * Resolve attribute value.
         * Only works for none isMany content providers!
         * 
         * TODO find posiibility in MD2 to handle isMany providers (e.g. :contentProvider(where firstName equals "John").lastName)
         * 
         * @param {String} attribute - Fully quallified name of the attribute (separated by dots).
         * @returns {Object} Value of the attribute or null if no value is set.
         */
        getValue: function(attribute) {
            var value = this._content[0];
            var pathSegments = attribute.split(".");
            array.forEach(pathSegments, function(pathSegment) {
                value = value ? value.get(pathSegment) : value;
            });
            return value;
        },
        
        /**
         * Only works for none isMany content providers!
         * 
         * TODO find posiibility in MD2 to handle isMany providers (e.g. :contentProvider(where firstName equals "John").lastName)
         * 
         * @param {type} attribute
         * @returns {unresolved}
         */
        setValue: function(attribute, newValue) {
            var pathSegments = attribute.split(".");
            var value = this._content[0];
            array.forEach(pathSegments, function(pathSegment, idx) {
                if (value && idx + 1 < pathSegments.length) {
                    value = value.get(pathSegment);
                } else {
                    // last path segment
                    var oldVal = value ? value.get(pathSegment) : value;
                    if (newValue && !newValue.equals(oldVal)) {
                        value.set(pathSegment, newValue.clone());
                        this._fireAllOnChanges(attribute);
                    }
                }
            }, this);
        },
        
        reset: function() {
            if (this._isManyProvider) {
                this._content = [];
            } else {
                var entityFactory = this._store.entityFactory;
                var newEntity = entityFactory.create();
                var newContent = [newEntity];
                this._setContent(newContent);
            }
        },
        
        load: function() {
            var name = this._name;
            var filter = this._filter ? this._filter() : {};
            var query = filter.query;
            var options = filter.count === "first" || !this._isManyProvider ? {
                count: 1
            } : null;
            
            this._store.query(query, options).then(lang.hitch(this, function(results) {
                if(results.length) {
                    this._setContent(this._isManyProvider ? results : [results[0]]);
                } else {
                    this.reset();
                }
                topic.publish(this._topicAction, "success", name, "load");
            }), lang.hitch(this, function(error) {
                topic.publish(this._topicAction, "error", name, "load", error);
            }));
        },
        
        save: function() {
            var name = this._name;
            
            this._store.put(this._content).then(lang.hitch(this, function(response) {
                
                // mixin internalIds from backend
                for(var i = 0; i < response.length; i++) {
                    this._content[i].setInternalID(response[i].__internalId);
                }
                
                topic.publish(this._topicAction, "success", name, "save");
            }), lang.hitch(this, function(error) {
                topic.publish(this._topicAction, "error", name, "save", error);
            }));
        },
        
        remove: function() {
            
            // get entities to delete
            var filtered = array.filter(this._content, function(entity) {
                return entity.hasInternalID();
            });
            
            // if there are no entities with an internal id, it was never loaded from the backend
            // => thus, there is no need to delete it from store
            if(!filtered.length) {
                topic.publish(this._topicAction, "success", this._name, "remove");
            } else {
                var ids = array.map(filtered, function(entity) {
                    return entity.getInternalID();
                }, this);
                
                this._store.remove(ids).then(function() {
                    topic.publish(this._topicAction, "success", this._name, "remove");
                }, function(error) {
                    topic.publish(this._topicAction, "error", this._name, "remove", error);
                });
            }
        },
        
        getName: function() {
            return this._name;
        }
        
    });
});
