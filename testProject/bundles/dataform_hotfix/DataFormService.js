define(["dojo/_base/lang","dojo/_base/declare","ct/Exception","./DataForm"],
    function(d_lang,declare,Exception,DataForm) {

        return declare([],
        {
            constructor : function(args){
                this.builderResolver = (args && args.builderResolver) || [];
                this.bindingResolver = (args && args.bindingResolver) || [];
                this.stores = {};
            },
            /**
            * @return dataform.DataForm
            */
            createDataForm: function (formResolveDescription, options) {
                var resolvers = this.builderResolver;
                var l = resolvers.length;
                for (var i=0;i<l;++i){
                    var resolver = resolvers[i];
                    var builder = resolver.resolveBuilder(formResolveDescription);
                    if (builder){
                        try{
                            var rootcontrol = builder.build();
                            var constrOpts = d_lang.mixin({
                                bodyControl : rootcontrol,
                                dataFormService : this
                            }, options || {});
                            return new DataForm(constrOpts);
                        }catch(e){
                            e = Exception.illegalStateError("unexpected exception during form building '"+e+"'",e);
                            console.error(e);
                            throw e;
                        }
                    }
                }
                throw Exception.illegalStateError("DataFormService: no builder resolver registered for '"+formResolveDescription+"'");
            },

            createBinding: function(bindingTypeIdentifier, opts){
                var resolvers = this.bindingResolver;
                var l = resolvers.length;
                for (var i=0;i<l;++i){
                    var resolver = resolvers[i];
                    var binding = resolver.resolveBinding(bindingTypeIdentifier, opts);
                    if (binding){
                        return binding;
                    }
                }
                throw Exception.illegalStateError("DataFormService: no binding resolver registered for '"+bindingTypeIdentifier+"'");
            },

            // callec by DataFrom to resolve a store for one of the controls
            resolveStoreEntry : function(dataForm,storeId){
                var entry = this.stores[storeId];
                if (entry){
                    return entry;
                }
                var binding = dataForm.get("dataBinding");
                if (binding && binding.getStore){
                    var store = binding.getStore(storeId);
                    if (store){
                        return {store:store};
                    }
                }
                return undefined;
            },
            addStore : function(store, props){
                var id = this._getIdFromPropsOrStore(store, props);
                if(id){
                    this.stores[id] = {
                        store : store,
                        props : props
                    }
                }
            },
            removeStore : function(store,props){
                var id = this._getIdFromPropsOrStore(store, props);
                if(id){
                    delete this.stores[id];
                    // TODO: inform created data forms about store removal?
                }
            },
            _getIdFromPropsOrStore : function(store, props) {
                props = props || {};
                // props are the important ones and can overwrite ids transported over the store
                return props.id || props.storeId || store.id || store.storeId;
            }
        });
    });