//
//  MD2ButtonWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 29.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A button element, either regular system buttons or info buttons used for tooltip hints.
class MD2ButtonWidget: MD2SingleWidget, MD2StylableWidget {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping
    
    /// The view element value. Using a property observer, external changes trigger a UI control update.
    var value: MD2Type {
        didSet {
            updateElement()
        }
    }
    
    /// Inner dimensions of the screen occupied by the widget.
    var dimensions: MD2Dimension?
    
    /// Button type, either standard or info button
    var buttonType: UIButtonType = UIButtonType.System
    
    /// The native UI control.
    var widgetElement: UIButton?
    
    /// The color as hex string.
    var color: MD2String?
    
    /// The font size as multiplicatve scaling factor (similar to 'em' in CSS).
    var fontSize: MD2Float? = MD2Float(1.0)
    
    /// The text style.
    var textStyle: MD2WidgetTextStyle = MD2WidgetTextStyle.Normal
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
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
        
        switch buttonType {
        case UIButtonType.System: renderSystemButton(view)
        case UIButtonType.InfoLight: renderInfoButton(view)
        default: renderSystemButton(view)
        }
    }
    
    /**
        Calculate the dimensions of the widget based on the available bounds. The occupied space of the widget is returned.
    
        *NOTICE* The occupied space may surpass the bounds (and thus the visible screen), if the height of the element is not sufficient. This is not a problem as the screen will scroll automatically.
    
        *NOTICE* The occupied space usually differs from the dimensions property as it refers to the *outer* dimensions in contrast to the dimensions property referring to *inner* dimensions. The difference represents the gutter included in the widget positioning process.
    
        :param: bounds The available screen space.

        :returns: The occupied outer dimensions of the widget.
    */
    func calculateDimensions(bounds: MD2Dimension) -> MD2Dimension {
        var outerDimensions = MD2Dimension(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: MD2ViewConfig.DIMENSION_BUTTON_HEIGHT)
        
        // Add gutter
        self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
        // If button already exists (=redraw on orientation change)
        widgetElement?.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        
        return outerDimensions
    }
    
    /// Enable the view element.
    func enable() {
        self.widgetElement?.enabled = true
    }
    
    /// Disable the view element.
    func disable() {
        self.widgetElement?.enabled = false
    }
    
    /**
        Render a regular system button.
    
        :param: view The surrounding view container.
    */
    func renderSystemButton(view: UIView) {
        // Create and set value
        widgetElement = (UIButton.buttonWithType(UIButtonType.System) as! UIButton)
        widgetElement!.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        updateElement()
        
        widgetElement!.tag = widgetId.rawValue
        widgetElement!.addTarget(MD2Event.OnClick.getEventHandler(), action: Selector(MD2Event.OnClick.getTargetMethod()), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set default styles
        widgetElement!.layer.borderWidth = 1
        widgetElement!.layer.cornerRadius = 15
        widgetElement!.titleLabel!.textAlignment=NSTextAlignment.Center
        
        // Set custom styles
        if color?.isSet() == true {
            widgetElement!.tintColor = UIColor(rgba: color!.platformValue!)
        }
        
        // Set more defaults
        widgetElement!.layer.borderColor = widgetElement!.tintColor?.CGColor
        widgetElement!.titleLabel!.font = UIFont(name: textStyle.rawValue, size: CGFloat(Float(MD2ViewConfig.FONT_SIZE) * fontSize!.platformValue!))
        
        // Add to surrounding view
        view.addSubview(widgetElement!)
    }
    
    /**
        Render an information button, used for example as tooltip hint.

        :param: view The surrounding view container.
    */
    func renderInfoButton(view: UIView) {
        widgetElement = (UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton)
        widgetElement!.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        widgetElement!.tag = widgetId.rawValue
        
        // Add alert handler
        widgetElement!.addTarget(MD2Event.OnTooltip.getEventHandler(), action: Selector(MD2Event.OnTooltip.getTargetMethod()), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add to surrounding view
        view.addSubview(widgetElement!)
    }
    
    /**
        Update the view element after its value was changed externally.
    */
    func updateElement() {
        widgetElement?.setTitle(self.value.toString(), forState: .Normal)
    }
}
