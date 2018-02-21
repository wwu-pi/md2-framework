//
//  MD2DataMapper.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    A data mapping mechanism for two-way synchronization of changes between input fields and content providers.
    
    *Notice* The class may bypass the event/action construct and use a direct form synchronization instead.
*/
class MD2DataMapper {
    
    /// Singleton instance of the REST client
    static let instance = MD2DataMapper()
    
    /// Private initializer for the singleton instance
    private init() {
        // Nothing to initialize
    }
    
    /**
        Content provider and attribute to widget association.
        
        *Notice* There is no native bidirectional data structure available and the overhead is acceptable because only object references are stored.
    */
    var contentProviderToWidgetMapping: Dictionary<MD2ContentProviderAttributeIdentity, MD2WidgetWrapper> = [:]
    
    /**
        Widget to content provider and attribute association.
        
        *Notice* There is no native bidirectional data structure available and the overhead is acceptable because only object references are stored.
    */
    var widgetToContentProviderMapping: Dictionary<MD2WidgetWrapper, MD2ContentProviderAttributeIdentity> = [:]
    
    /**
        Install the binding between a widget wrapper and a content provider and attribute combination.
        
        On change of the input field or the content provider a respective event is fired to update the mapping partner.
        
        :param: widget The widget wrapper of the input field.
        :param: contentProvider The content provider for data storage.
        :param: attribute The attribute to specify the field of the content provider.
    */
    func map(widget: MD2WidgetWrapper, contentProvider: MD2ContentProvider, attribute: String) {
        // Add mapping
        contentProviderToWidgetMapping[MD2ContentProviderAttributeIdentity(contentProvider, attribute)] = widget
        widgetToContentProviderMapping[widget] = MD2ContentProviderAttributeIdentity(contentProvider, attribute)
        
        // Add respective action on change
        let providerChangeAction = MD2UpdateWidgetAction(
            actionSignature: MD2Util.getClassName(contentProvider) + "__" + attribute + "__" + widget.widgetId.description,
            viewElement: widget,
            contentProvider: contentProvider,
            attribute: attribute)
        MD2OnContentChangeHandler.instance.registerAction(providerChangeAction, contentProvider: contentProvider, attribute: attribute)
        
        let fieldChangeAction = MD2UpdateContentProviderAction(
            actionSignature: MD2Util.getClassName(contentProvider) + "__" + attribute + "__" + widget.widgetId.description,
            viewElement: widget,
            contentProvider: contentProvider,
            attribute: attribute)
        MD2OnWidgetChangeHandler.instance.registerAction(fieldChangeAction, widget: widget)

        // Add content provider observer and trigger first value update
        contentProvider.registerObservedOnChange(attribute)
    }

    /**
        Revoke the binding between a widget wrapper and a content provider and attribute combination.
        
        :param: widget The widget wrapper of the input field.
        :param: contentProvider The content provider for data storage.
        :param: attribute The attribute to specify the field of the content provider.
    */
    func unmap(widget: MD2WidgetWrapper, contentProvider: MD2ContentProvider, attribute: String) {
        // Remove mapping
        contentProviderToWidgetMapping.removeValueForKey(MD2ContentProviderAttributeIdentity(contentProvider, attribute))
        widgetToContentProviderMapping.removeValueForKey(widget)
        
        // Remove content provider observer
        contentProvider.unregisterObservedOnChange(attribute)
        
        // Remove onChange action
        let action = MD2UpdateWidgetAction(actionSignature: MD2Util.getClassName(contentProvider), viewElement: widget, contentProvider: contentProvider, attribute: attribute)
        MD2OnContentChangeHandler.instance.unregisterAction(action, contentProvider: contentProvider, attribute: attribute)
        
        let fieldChangeAction = MD2UpdateContentProviderAction(actionSignature: MD2Util.getClassName(contentProvider), viewElement: widget, contentProvider: contentProvider, attribute: attribute)
        MD2OnWidgetChangeHandler.instance.unregisterAction(fieldChangeAction, widget: widget)

        // Remove mapping
        widgetToContentProviderMapping.removeValueForKey(widget)
    }
    
    /**
        Retrieve the widget wrapper for a content provider and attribute combination.
        
        :param: contentProvider The content provider for data storage.
        :param: attribute The attribute to specify the field of the content provider.
        
        :returns: The respective widget wrapper if found.
    */
    func getWidgetForContentProvider(contentProvider: MD2ContentProvider, attribute: String) -> MD2WidgetWrapper? {
        return contentProviderToWidgetMapping[MD2ContentProviderAttributeIdentity(contentProvider, attribute)]
    }
    
    /**
        Retrieve the content provider for a widget wrapper.
        
        :param: widget The widget wrapper of the input field.
        
        :returns: The respective content provider and attribute combination if found.
    */
    func getContentProviderForWidget(widget: MD2WidgetWrapper) -> MD2ContentProviderAttributeIdentity? {
        return widgetToContentProviderMapping[widget]
    }
}