define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/_base/array",
    "ct/_lang",
    "ct/_when",
    "dojo/Deferred",
    "dojo/store/util/QueryResults",
    "dojo/json",
    "dojo/cookie"
], function(declare, lang, array, ct_lang, ct_when, Deferred, QueryResults, json, cookie) {
    
    return declare([], {
        
        /**
         * The factory of the entity that is managed by this store. It is used to construct new instances of this
         * entity, and populate it with the values received from the backend. Furthermore, it
         * is provided to the content provider (e.g. to reset the content provider).
         */
        entityFactory: undefined,
        
        constructor: function(options) {
            declare.safeMixin(this, options);
        },
        
        query: function(query, options) {
            
            var deferred = new Deferred();
            
            setTimeout(lang.hitch(this, function(){
                var result = cookie(this.entityFactory.datatype);
                result && (result = json.parse(result));
                deferred.resolve(this._translateToMD2Types(result));
            }), 100);
            
            return QueryResults(deferred.promise);
        },
        
        get: function(id) {
            return ct_when(this.query(), lang.hitch(this, function(result) {
                result = this._translateToMD2Types(result);
                return result.length ? result[0] : null;
            }));
        },
        
        put: function(object, options) {
            
            var deferred = new Deferred();
            setTimeout(lang.hitch(this, function(){
                var jsObject = this._translateToJSTypes(object);
                cookie(this.entityFactory.datatype, json.stringify(jsObject), { expires: 365 });
                deferred.resolve([1]);
            }), 100);
            
            return deferred.promise;
        },
        
        add: function(object, options) {
            return this.put(object, options);
        },
        
        remove: function(ids) {
            
            var deferred = new Deferred();
            setTimeout(lang.hitch(this, function(){
                cookie(this.entityFactory.datatype, "", { expires: 0 });
                deferred.resolve();
            }), 100);
            
            return deferred.promise;
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
