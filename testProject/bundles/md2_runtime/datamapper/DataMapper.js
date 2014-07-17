define([
    "dojo/_base/declare", "dojo/_base/lang", "ct/Hash"
],

function(declare, lang, Hash) {
    return declare([], {
        
        _contentProviderToWidgetMapping: null,
        
        _widgetToContentProviderMapping: null,
        
        constructor: function() {
            this._contentProviderToWidgetMapping = new Hash();
            this._widgetToContentProviderMapping = new Hash();
        },
        
        map: function(widget, contentProvider, attribute) {
            
            var key = contentProvider.getName() + "$" + attribute;
            var id = widget.getId();
            
            // ContentProvider to FormControl mapping
            var toWidgetMapping = this._contentProviderToWidgetMapping;
            if(!toWidgetMapping.contains(id)) {
                toWidgetMapping.set(id, new Hash());
            }
            var contentProviderTargets = toWidgetMapping.get(id);
            contentProviderTargets.set(key, {
                contentProvider: contentProvider,
                attribute: attribute
            });
            
            // FormControl to ContentProvider mapping
            var toContentProviderMapping = this._widgetToContentProviderMapping;
            if(!toContentProviderMapping.contains(key)) {
                toContentProviderMapping.set(key, new Hash());
            }
            var widgets = toContentProviderMapping.get(key);
            widgets.set(id, widget);
            
            // Set current content provider value in form field (called on formControl)
            if (widget.getWidget()) {
                widget.getWidget().refreshBinding();
            } else {
                widget.setValue(contentProvider.getValue(attribute));
            }
            
            contentProvider.registerObservedOnChange(attribute);
        },
        
        unmap: function(widget, contentProvider, attribute) {
            
            var key = contentProvider.getName() + "$" + attribute;
            var id = widget.getId();
            
            // ContentProvider to FormControl mapping
            var toWidgetMapping = this._contentProviderToWidgetMapping;
            if(toWidgetMapping.contains(id)) {
                toWidgetMapping.get(id).remove(key);
            }
            
            // FormControl to ContentProvider mapping
            var toContentProviderMapping = this._widgetToContentProviderMapping;
            if(toContentProviderMapping.contains(key)) {
                toContentProviderMapping.get(key).remove(id);
            }
            
            contentProvider.unregisterObservedOnChange(attribute);
        },
        
        getContentProviders: function(widgetOrFieldName) {
            var toWidgetMapping = this._contentProviderToWidgetMapping;
            
            var fieldName = lang.isString(widgetOrFieldName)
                          ? widgetOrFieldName
                          : widgetOrFieldName.getId();
            
            if(toWidgetMapping.contains(fieldName)) {
                return toWidgetMapping.get(fieldName);
            } else {
                return new Hash();
            }
        },
        
        getWidgets: function(contentProviderOrName, attribute) {
            var toContentProviderMapping = this._widgetToContentProviderMapping;
            var contentProviderName = lang.isString(contentProviderOrName)
                                    ? contentProviderOrName
                                    : contentProviderOrName.getName();
            var key = contentProviderName + "$" + attribute;
            
            if(toContentProviderMapping.contains(key)) {
                return toContentProviderMapping.get(key);
            } else {
                return new Hash();
            }
        }
        
    });
});
