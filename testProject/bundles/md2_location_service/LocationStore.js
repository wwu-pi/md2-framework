define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "ct/_lang", "ct/_when", "ct/request", "ct/store/StoreUtil", "dojo/store/util/QueryResults", "dojo/json", "dojo/request/xhr"
], function(declare, lang, array, ct_lang, ct_when, ct_request, StoreUtil, QueryResults, JSON, xhr) {
    
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
            
            // ensure trailing slash
            !this.url && window.console && console.error("MD2Store: url property in options is not set!");
            this.url = this.url.replace(/\/+$/, "") + "/";
        },
        
        query: function(query, options) {
            
            var url = (options && options.count === 1) ? this.url.concat("first") : this.url;
            var content = query ? {
                filter: this._complexQueryTranslator(query)
            } : {};
            
            var promise = ct_when(ct_request({
                url: url,
                content: content
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
            
            return xhr.put(ct_request.getProxiedUrl(this.url, true), {
                data: JSON.stringify([jsObject]),
                handleAs: "json",
                headers : headers
            });
        },
        
        add: function(object, options) {
            this.put(object, options);
        },
        
        remove: function(id) {
            return xhr.del(ct_request.getProxiedUrl(this.url.concat("delete/", id), true), {});
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
                    filterString += "(";
                    switch(key) {
                        case "$and":
                            filterString += this._logicalOperator(query[key], "and");
                            break;
                        case "$or":
                            filterString += this._logicalOperator(query[key], "or");
                            break;
                    }
                    filterString += ")";
                } else {
                    if(lang.isObject(query[key])) {//alert(JSON.stringify(query[key]));
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
                        expression += "not".concat("(", this._operatorExpression(value, prop), ")");
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
                if (md2Entity.get(name)) {
                    md2Entity.set(name, md2Entity.get(name).create(value));
                } else {
                    var subMD2Entity = md2Entity._typeFactory.createEntity(md2Entity.attributeTypes[name]);
                    this._translateToMD2TypesRecursion(subMD2Entity, platformEntity[name]);
                }
            }, this);
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
            ct_lang.forEachOwnProp(md2Entity._attributes, function(value, name) {
                if (value.toPlatformValue) {
                    platformEntity[name] = value.toPlatformValue();
                } else {
                    platformEntity[name] = this._translateToJSTypesRecursion(value);
                }
            }, this);
            return platformEntity;
        }
        
    });
});
