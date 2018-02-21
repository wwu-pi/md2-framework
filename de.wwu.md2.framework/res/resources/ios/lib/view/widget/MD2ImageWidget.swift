//
//  MD2ImageWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 29.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Image widget outputting an image from a source link. 
class MD2ImageWidget: MD2SingleWidget {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping
    
    // path relative to /resources/images
    var value: MD2Type {
        didSet {
            updateElement()
        }
    }
    
    /// Inner dimensions of the screen occupied by the widget.
    var dimensions: MD2Dimension?
    
    /// The native UI control.
    var widgetElement: UIImageView
    
    /// Height of the widget in pixels.
    var height: Float?
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /**
        Default initializer.
        
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
        self.widgetElement = UIImageView()
    }
    
    /**
        Render the view element, i.e. specifying the position and appearance of the widget.
    
        :param: view The surrounding view element.
        :param: controller The responsible view controller.
    */
    func render(view: UIView, controller: UIViewController) {
        if dimensions == nil {
            // Element is not specified in layout. Maybe grid with not enough cells?!
            return
        }
        
        // Default parameters
        widgetElement.contentMode = UIViewContentMode.ScaleAspectFit
        
        // Set value
        updateElement()
        
        // Add to surrounding view
        view.addSubview(widgetElement)
    }
    
    /**
        Calculate the dimensions of the widget based on the available bounds. The occupied space of the widget is returned.
    
        *NOTICE* The occupied space may surpass the bounds (and thus the visible screen), if the height of the element is not sufficient. This is not a problem as the screen will scroll automatically.
    
        *NOTICE* The occupied space usually differs from the dimensions property as it refers to the *outer* dimensions in contrast to the dimensions property referring to *inner* dimensions. The difference represents the gutter included in the widget positioning process.
    
        :param: bounds The available screen space.
    
        :returns: The occupied outer dimensions of the widget.
    */
    func calculateDimensions(bounds: MD2Dimension) -> MD2Dimension {
        let outerDimensions = MD2Dimension(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: MD2ViewConfig.DIMENSION_IMAGE_HEIGHT)
        
        // Add gutter
        self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
        widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        
        return outerDimensions
    }
    
    /// Enable the view element.
    func enable() {
        // Nothing to do on a read-only element
    }
    
    /// Disable the view element.
    func disable() {
        // Nothing to do on a read-only element
    }
    
    /**
        Update the view element after its value was changed externally.
    */
    func updateElement() {
        // Image from URL (synchronous call)
        if let url = NSURL(string: value.toString()) {
            if let data = NSData(contentsOfURL: url) {
                widgetElement.image = UIImage(data: data)
            }
        }
    }
}