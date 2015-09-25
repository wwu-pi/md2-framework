//
//  MD2LabelWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 29.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A stylable text output element.
class MD2LabelWidget: MD2SingleWidget, MD2StylableWidget {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping
    
    /// The view element value. Using a property observer, external changes trigger a UI control update.
    var value: MD2Type {
        didSet {
            updateElement()
        }
    }
    
    /// Inner dimensions of the screen occupied by the widget
    var dimensions: MD2Dimension?
    
    /// The native UI control.
    var widgetElement: UILabel
    
    /// The color as hex string.
    var color: MD2String?
    
    /// The font size as multiplicatve scaling factor (similar to 'em' in CSS).
    var fontSize: MD2Float? = MD2Float(1.0)
    
    /// The text style.
    var textStyle: MD2WidgetTextStyle = MD2WidgetTextStyle.Normal
    
    /// Width of the widget as specified by the model (percentage of the availale width)
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
        self.widgetElement = UILabel()
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
        
        // Set value
        updateElement()
        
        // Set default styles
        //widgetElement.textAlignment = .Center
        widgetElement.numberOfLines = 2
        widgetElement.lineBreakMode = .ByWordWrapping
        
        // Set custom styles
        if color?.isSet() == true {
            widgetElement.textColor = UIColor(rgba: color!.platformValue!)
        }
        
        widgetElement.font = UIFont(name: textStyle.rawValue, size: CGFloat(Float(MD2ViewConfig.FONT_SIZE) * fontSize!.platformValue!))
        
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
            height: MD2ViewConfig.DIMENSION_LABEL_HEIGHT)
        
        // Add gutter
        dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
        widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        
        return outerDimensions
    }
    
    /// Enable the view element.
    func enable() {
        self.widgetElement.enabled = true
    }
    
    /// Disable the view element.
    func disable() {
        self.widgetElement.enabled = false
    }
    
    func updateElement() {
        self.widgetElement.text = value.toString()
    }

}