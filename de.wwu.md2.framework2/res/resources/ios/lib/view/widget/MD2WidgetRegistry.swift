//
//  MD2WidgetRegistry.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 28.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Registry for view elements.
class MD2WidgetRegistry {
    
    /// The singleton instance.
    static let instance: MD2WidgetRegistry = MD2WidgetRegistry()
    
    /// Collection of registered widgets.
    var widgets: Dictionary<MD2WidgetMapping, MD2WidgetWrapper> = [:]
    
    /// Singleton initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Register a widget wrapper.
    
        :param: widget The widget wrapper to register.
    */
    func add(widget: MD2WidgetWrapper) {
        widgets[widget.widgetId] = widget
    }
    
    /**
        Retrieve a widget object.

        :param: id The identifier of the widget.
    
        :returns: The widget wrapper element if found.
    */
    func getWidget(id: MD2WidgetMapping) -> MD2WidgetWrapper? {
        return widgets[id]
    }
    
}