define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "ct/_lang",
    "ct/_when",
    "ct/request",
    "ct/store/StoreUtil",
    "dojo/store/util/QueryResults",
    "dojo/json",
    "dojo/request/xhr"
], function(declare, lang, array, ct_lang, ct_when, ct_request, StoreUtil, QueryResults, json, xhr) {
    
    return declare([], {
        
        /** 
         * Defines the Accept header to use on HTTP requests
         */
        accepts: "application/javascript, application/json",
        
        /**
         * Additional headers to pass in all requests to the server. These can be overridden
         * by passing additional headers to calls to the store.
         */
        headers: {},
        
        /**
         * URL of the web service
         */
        url: null,
        
        /**
         * On every request:
         * Check header of the response on whether it equals the required model version defined in the store.
         */
        checkModelVersion: false,
        
        /**
         * If the model version check is activated, the expected model version of the backend can be defined here
         */
        currentModelVersion: null,
        
        /**
         * The factory of the entity that is managed by this store. It is used to construct new instances of this
         * entity, and populate it with the values received from the backend. Furthermore, it
         * is provided to the content provider (e.g. to reset the content provider).
         */
        entityFactory: undefined,
        
        constructor: function(options) {
            declare.safeMixin(this, options);
            
            if (!this.url) {
                throw new Error("[MD2Store] Required property 'url' in options is not set!");
            }
            
            // ensure trailing slash
            this.url = this.url.replace(/\/+$/, "") + "/";
        },
        
        query: function(query, options) {
            
            var url = this.url;
            var parameters = {};
            
            if (query) {
                this._makePlainJSObjectWithStringValues(query);
                parameters.filter = this._complexQueryTranslator(query);
                console && console.debug("[MD2Store] Vanilla query object: ", query);
                console && console.debug("[MD2Store] Filter string: ", parameters.filter);
            }
            
            if (options && options.count) {
                parameters.limit = options.count;
            }
            
            var promise = ct_when(ct_request({
                url: url,
                content: parameters
            }), function(response) {
                var result = lang.isArray(response) ? response : [response];
                var total = result.length;
                result = StoreUtil.sort(result, options);
                result.total = total;
                return this._translateToMD2Types(result);
            }, this);
            
            // need delegate, because the promise is frozen in chrome
            promise = lang.delegate(promise, {
                total: promise.then(function(result) {
                    return result.total;
                })
            });
            
            return QueryResults(promise);
        },
        
        get: function(id) {
            return ct_when(this.query({__internalId: id}, {count: 1}), lang.hitch(this, function(result) {
                result = this._translateToMD2Types(result);
                return result.length ? result[0] : null;
            }));
        },
        
        put: function(object, options) {
            options = options || {};
            
            var jsObject = this._translateToJSTypes(object);
            
            var headers = lang.mixin({
                "Content-Type": "application/json",
                Accept: this.accepts
            }, this.headers, options.headers || {});
            
            return xhr.post(ct_request.getProxiedUrl(this.url, true), {
                data: json.stringify(jsObject),
                handleAs: "json",
                headers : headers
            });
        },
        
        add: function(object, options) {
            return this.put(object, options);
        },
        
        remove: function(ids) {
            /*
             * Use [GET] {service_url}/delete, because the ESRI proxy is not capable of
             * handling [DELETE] requests.
             */
            return xhr.get(ct_request.getProxiedUrl(this.url.concat("delete/"), true), {
                query: {
                    id: ids
                }
            });
        },
        
        /**
         * Tarnsforms an object (not an entity!) with md2 datatypes into a
         * plain JS object with string values. This is the basis for the filter string.
         * @param {type} obj
         * @returns {Object} - Vanilla object
         */
        _makePlainJSObjectWithStringValues: function(obj) {
            ct_lang.forEachOwnProp(obj, function(value, key) {
                if (value.hasOwnProperty("_platformValue")) {
                    obj[key] = value.toString();
                } else if (lang.isObject(value)) {
                    this._makePlainJSObjectWithStringValues(value);
                }
            }, this);
        },
        
        /**
         * Translates a query in the mongodb JSON-notation that is used by map.apps' ComplexQuery
         * notation into a query string that is supported by the MD2 backend.
         * 
         * @param {Object} query - ComplexQuery as specified in the mongodb JSON-notation.
         * @returns {string} Filter string as required by the md2 backend.
         */
        _complexQueryTranslator: function(query) {
            var filterString = "";
            var i = 1;
            for(var key in query) {
                if(!query.hasOwnProperty(key)) {
                    continue;
                }
                
                if(key.charAt(0) === "$") {
                    switch(key) {
                        case "$and":
                            filterString += this._logicalOperator(query[key], "and");
                            break;
                        case "$or":
                            filterString += "(";
                            filterString += this._logicalOperator(query[key], "or");
                            filterString += ")";
                            break;
                        case "$not":
                            filterString += "not(";
                            filterString += this._complexQueryTranslator(query[key]);
                            filterString += ")";
                            break;
                    }
                } else {
                    if(lang.isObject(query[key])) {
                        // nested entity
                        filterString += this._operatorExpression(query[key], key);
                    } else {
                        filterString += key.concat(" equals ", this._quotify(query[key]));
                    }
                }
                
                if(this._getObjectSize(query) > i) filterString += " and ";
                i++;
            }
            
            return filterString;
        },
        
        _logicalOperator: function(expressionArr, operator) {
            var partials = [];
            for(var i = 0; i < expressionArr.length; i++) {
                partials.push(this._complexQueryTranslator(expressionArr[i]));
            }
            return partials.join(" ".concat(operator, " "));
        },
        
        _operatorExpression: function(exp, prop) {
            var i = 1;
            var expression = "";
            
            // 
            // The object might express a range and thus has to be iterated.
            // E.g. (x > 1 && x < 5) can be represented as follows:
            // 
            //     store.query({
            //       x: {
            //         $gt: 1,
            //         $lt: 5
            //       }
            //     });
            // 
            for(var key in exp) {
                var value = this._quotify(exp[key]);
                switch(key) {
                    case "$not":
                        expression += "not".concat("(", this._operatorExpression(exp[key], key), ")");
                        break;
                    case "$eq":
                        expression += prop.concat(" equals ", value);
                        break;
                    case "$ne":
                        expression += "not".concat("(", prop, " equals ", value, ")");
                        break;
                    case "$gt":
                        expression += prop.concat(" greater ", value);
                        break;
                    case "$lt":
                        expression += prop.concat(" smaller ", value);
                        break;
                    case "$gte":
                        expression += prop.concat(" >= ", value);
                        break;
                    case "$lte":
                        expression += prop.concat(" <= ", value);
                        break;
                }
                
                if(this._getObjectSize(exp) > i) expression += " and ";
                i++;
            }
            
            return (this._getObjectSize(exp) > 1) ? "(" + expression + ")" : expression;
        },
        
        _getObjectSize: function(object) {
            if(Object.keys) {
                return Object.keys(object).length;
            }
            
            var size = 0;
            for(var key in object) {
                if(object.hasOwnProperty(key)) size++;
            }
            return size;
        },
        
        _quotify: function(expr) {
            return lang.isString(expr) ? "\"".concat(expr, "\"") : expr;
        },
        
        /**
         * Translate an entity with platform (JS) values to an entity
         * with MD2 datatypes. If platformEntity is missing properties they are
         * implicitly set to the default values specified for this entity type.
         * 
         * @param {Array} platformEntities - Array of entities with JS values.
         * @returns {Array} Array of entities with MD2 typed values.
         */
        _translateToMD2Types: function(platformEntities) {
            var md2Entities = [];
            array.forEach(platformEntities, function(platformEntity) {
                var md2Entity = this._translateToMD2TypesRecursion(this.entityFactory.create(), platformEntity);
                md2Entities.push(md2Entity);
            }, this);
            return md2Entities;
        },
        
        _translateToMD2TypesRecursion: function(md2Entity, platformEntity) {
            ct_lang.forEachOwnProp(platformEntity, function(value, name) {
                if (name === "__internalId") {
                    md2Entity.setInternalID(value);
                } else {
                    if (md2Entity.get(name)) {
                        md2Entity.set(name, md2Entity.get(name).create(value));
                    } else {
                        var subMD2Entity = md2Entity._typeFactory.createEntity(md2Entity.attributeTypes[name]);
                        md2Entity.set(name, this._translateToMD2TypesRecursion(subMD2Entity, platformEntity[name]));
                    }
                }
            }, this);
            return md2Entity;
        },
        
        _translateToJSTypes: function(md2Entities) {
            var platformEntities = [];
            array.forEach(md2Entities, function(md2Entity) {
                var platformEntity = this._translateToJSTypesRecursion(md2Entity);
                platformEntities.push(platformEntity);
            }, this);
            return platformEntities;
        },
        
        _translateToJSTypesRecursion: function(md2Entity) {
            var platformEntity = {};
            if (md2Entity.getInternalID()) {
                platformEntity["__internalId"] = md2Entity.getInternalID();
            }
            ct_lang.forEachOwnProp(md2Entity._attributes, function(value, name) {
                if (value.getPlatformValue) {
                    platformEntity[name] = value.getPlatformValue();
                } else {
                    platformEntity[name] = this._translateToJSTypesRecursion(value);
                }
            }, this);
            return platformEntity;
        }
        
    });
});
