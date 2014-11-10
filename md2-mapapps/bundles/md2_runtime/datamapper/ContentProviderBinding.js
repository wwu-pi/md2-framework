define([
    "dojo/_base/declare", "dojo/_base/lang", "dojo/topic", "ct/Stateful"
], function(declare, lang, topic, Stateful) {
    
    return declare([], {
        
        constructor: function(opts) {
            if (!opts.dataMapper) {
                throw new Error("[ContentProviderBinding] Missing option 'dataMapper'!");
            }
            this._dataMapper = opts.dataMapper;
            this._typeFactory = opts.typeFactory;
            this._appId = opts.appId;
            this._watchers = new Stateful();
            this._contentProviderOnChange();
        },
        
        destroy: function() {
            this._contentProviderListener.remove();
        },
        
        get: function(fieldname, index) {
            // only get value from first mapping -- all other mappings should be equal or will be set to first mapping
            var value = undefined;
            this._dataMapper.getContentProviders(fieldname).forEach(function(target) {
               var attribute = target.attribute;
               value = target.contentProvider.getValue(attribute);
               value = value ? value.getPlatformValue() : value;
               return false;
           });
           return value;
        },
        
        set: function(fieldname, val, index) {
            // set value in all mapped content providers
            this._dataMapper.getContentProviders(fieldname).forEach(function(target) {
                var attribute = target.attribute;
                var contentProvider = target.contentProvider;
                var typedValue = contentProvider.getValue(attribute).create(val);
                contentProvider.setValue(attribute, typedValue);
            }, this);
        },
        
        watch: function(fieldname, cb) {
            return this._watchers.watch(fieldname, cb);
        },
        
        _contentProviderOnChange: function() {
            // register handler for content provider on change events and notify all watchers
            var topicName = "md2/contentProvider/onChange/" + this._appId;
            var ref = topic.subscribe(topicName, lang.hitch(this, function(contentProvider, attribute, newVal, oldVal) {
                var widgets = this._dataMapper.getWidgets(contentProvider, attribute);
                widgets.forEach(function(widget) {
                    var fieldName = widget.getId();
                    this._watchers._firePropertyChange(
                        fieldName,
                        oldVal ? oldVal.getPlatformValue() : oldVal,
                        newVal ? newVal.getPlatformValue() : newVal
                    );
                    
                    var newValue = this._typeFactory.create(widget._datatype, newVal);
                    if (!newValue.equals(widget.getValue())) {
                        widget.setValue(newValue);
                    }
                }, this);
            }));
            this._contentProviderListener = ref;
        }
    });
});
