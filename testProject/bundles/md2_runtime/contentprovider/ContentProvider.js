define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/topic", "ct/_lang"
],

/**
 * ContentProviders hold an instance of the actual object from the backend and provide an interface
 * to access the local copies of the object(s), save all objects hold by the ContentProvider to the
 * web service/database, load specified objects from the web service/database and to remove the managed
 * objects from the web service/database.
 * 
 * The ContentProvider might access fields in the dataForm to configure its filter.
 */
function(declare, lang, array, topic, ct_lang) {
    
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
         * ComplexQuery object to describe the load filter for this content provider.
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
        _topicAction: "md2/contentProvider/dataAction",
        
        /**
         * Identifier of the topic this content provider publishes to for onChange events.
         */
        _topicOnChange: "md2/contentProvider/onChange",
        
        /**
         * Debug messages
         */
        _DEBUG_MSG: {
            nameParamErr: "MD2ContentProvider: The required parameter 'name' is not passed to the constructor!",
            storeParamErr: "MD2ContentProvider: The required parameter 'store' is not passed to the constructor!",
            objParamErr: "MD2ContentProvider: The required parameter 'objectOrArray' is not passed to setManagedContent!",
            idMissingWarn: "MD2ContentProvider.setManagedContent: __internalId of passed object missing. Cannot merge!"
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
         * @param {MD2Store} store
         * @param {Object} filter
         */
        constructor: function(name, store, filter) {
            !name && window.console && window.console.error(this._DEBUG_MSG["nameParamErr"]);
            !store && window.console && window.console.error(this._DEBUG_MSG["storeParamErr"]);
            this._name = name;
            this._store = store;
            this._content = [];
            this._filter = filter;
            this.reset();
        },
        
        getContent: function() {
            return this._isManyProvider ? this._content : this._content[0];
        },
        
        /**
         * Accepts incomplete objects and merges them with the managed content stored in this
         * ContentProvider. If the stored content is an array of objects the passed object has to
         * contain the __internalId of the object to update. If only a single object is managed by
         * this ContentProvider it is sufficient to only pass the property that has to be updated.
         * 
         * Hint: This method is not safe in the sense that it also mixes in properties that do not exist in the
         *       original object managed by this store. This might lead to problems with the backend when saving
         *       the content of this provider. The user of this class has to take care to not mixin such properties.
         * 
         * @param {Object} objectOrArray Object that contains the properties to update or array of objects with
         *                               the according properties to update.
         */
        setContent: function(objectOrArray) {
            !objectOrArray && window.console && window.console.error(this._DEBUG_MSG["objParamErr"]);
            objectOrArray = lang.isArray(objectOrArray) ? objectOrArray : [objectOrArray];
            
            // No performance optimizations. Runs in O(n^2) as only small collections are assumed to be managed.
            if(this._isManyProvider) {
                array.forEach(objectOrArray, function(passedObj) {
                    if(!passedObj.hasOwnProperty("__internalId")) {
                        // merge with initial object and add to array
                        var clone = lang.clone(this._entityBlueprint);
                        lang.mixin(clone, passedObj);
                        objectOrArray.push(clone);
                        window.console && window.console.warn(this._DEBUG_MSG["idMissingWarn"]);
                    } else {
                        // find and update entity instance
                        array.forEach(this._content, function(managedObj) {
                            if(passedObj.__internalId === managedObj.__internalId) {
                                lang.mixin(managedObj, passedObj);
                            }
                        });
                    }
                }, this);
            } else { // single object
                lang.mixin(this._content[0], objectOrArray);
            }
            
        },
        
        /**
         * Only works for none isMany content providers! For all other providers values cannot be got.
         * 
         * TODO find posiibility in MD2 to handle isMany providers (e.g. :contentProvider(where firstName equals "John").lastName)
         * 
         * @param {String} attribute - Fully quallified name of the attribute (separated by dots).
         * @returns {Object} Value of the attribute or null if no value is set.
         */
        getValue: function(attribute) {
            var pathSegments = attribute.split(".");
            var value = this._content[0];
            array.forEach(pathSegments, function(pathSegment) {
                if (value && lang.isObject(value)) {
                    value = value[pathSegment];
                }
            });
            return value;
        },
        
        /**
         * Only works for none isMany content providers! For all other providers values cannot be got.
         * 
         * TODO find posiibility in MD2 to handle isMany providers (e.g. :contentProvider(where firstName equals "John").lastName)
         * 
         * @param {type} attribute
         * @returns {unresolved}
         */
        setValue: function(attribute, value) {
            var pathSegments = attribute.split(".");
            var attr = this._content[0];
            array.forEach(pathSegments, function(pathSegment, idx) {
                if (attr && idx + 1 < pathSegments.length) {
                    attr = attr[pathSegment];
                } else {
                    // last path segment
                    var oldVal = attr[pathSegment];
                    if (value && !value.equals(oldVal)) {
                        attr[pathSegment] = value;
                        topic.publish(this._topicOnChange, this, attribute, value, oldVal);
                    }
                }
            }, this);
        },
        
        reset: function() {
            if (this._isManyProvider) {
                this._content = [];
            } else {
                var blueprint = this._store.entity;
                
                // initial reset: directly after content provider creation,
                // content is empty
                if (!this._content[0]) {
                    this._content = [lang.clone(blueprint)];
                }
                
                // if this provider only manages a single entity instance, overwrite
                // all values with the default values
                ct_lang.forEachOwnProp(blueprint, function(value, name){
                    this.setValue(name, value.create(value));
                }, this);
            }
        },
        
        load: function() {
            var name = this._name;
            var filter = this._filter || {};
            var query = lang.clone(filter.query);
            var options = filter.count === "first" || !this._isManyProvider ? {
                count: 1
            } : null;
            this._replacePlaceholdersInQuery(query);
            
            this._store.query(query, options).then(lang.hitch(this, function(results) {
                if(results.length) {
                    this._content = this._isManyProvider ? results : [results[0]];
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
                    this._content[i].__internalId = response[i].__internalId;
                }
                
                topic.publish(this._topicAction, "success", name, "save");
            }), lang.hitch(this, function(error) {
                topic.publish(this._topicAction, "error", name, "save", error);
            }));
        },
        
        remove: function() {
            
            // get entities to delete
            var filtered = array.filter(this._content, function(obj) {
                return obj.hasOwnProperty("__internalId");
            });
            
            var delCount = filtered.length;
            var errMsg = null;
            var topicPost = lang.hitch(this, function(error) {
                delCount--;
                errMsg = error || errMsg;
                if(delCount === 0 && !errMsg) {
                    topic.publish(this._topicAction, "success", this._name, "remove");
                } else if(delCount === 0 && errMsg) {
                    topic.publish(this._topicAction, "error", this._name, "remove", errMsg);
                }
            });
            
            // if there are no entities with an internal id, it was never loaded from the backend
            // => thus, there is no need to delete it from store
            if(!filtered.length) {
                topic.publish(this._topicAction, "success", this._name, "remove");
            } else {
                array.forEach(filtered, function(obj) {
                    this._store.remove(obj.__internalId).then(function(response) {
                        topicPost();
                    }, function(error) {
                        topicPost(error);
                    });
                }, this);
            }
        },
        
        getName: function() {
            return this._name;
        },
        
        _replacePlaceholdersInQuery: function(query) {
            
            if(!query) {
                return;
            }
            
            var dataMapper = this._filter.dataMapper;
            
            for(var key in query) {
                
                if(!query.hasOwnProperty(key)) {
                    continue;
                }
                
                var val = query[key];
                if(lang.isObject(val)) {
                    this._replacePlaceholdersInQuery(val);
                } else if(lang.isArray(val)) {
                    array.forEach(val, function(obj) {
                        this._replacePlaceholdersInQuery(obj);
                    }, this);
                } else if(lang.isString(val) && val.charAt(0) === "@") {
                    var mapping = dataMapper.getMapping(val.substring(1));
                    var realValue;
                    if(mapping.contentProvider) {
                        var content = mapping.contentProvider.getContent();
                        realValue = content[mapping.propertyName];
                    }
                    query[key] = realValue || null;
                }
            }
        }
        
    });
});
