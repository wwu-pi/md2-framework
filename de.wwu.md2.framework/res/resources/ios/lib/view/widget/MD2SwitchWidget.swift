//
//  MD2SwitchWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 29.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A switch widget to represent binary values.
class MD2SwitchWidget: MD2SingleWidget, MD2AssistedWidget {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping
    
    /// The view element value. Using a property observer, external changes trigger a UI control update.
    var value: MD2Type {
        didSet (oldValue) {
            // Check for type
            if !(value is MD2Boolean) {
                self.value = oldValue
            }
            
            updateElement()
        }
    }
    
    /// Inner dimensions of the screen occupied by the widget.
    var dimensions: MD2Dimension?
    
    /// The native UI control.
    var widgetElement: UISwitch
    
    /// The caption for the switch.
    var label: MD2String?
    
    /// The tooltip text to display for assistance.
    var tooltip: MD2String?
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2Boolean(false)
        self.widgetElement = UISwitch()
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
        
        // TODO Label for caption
        if (value is MD2Boolean) && (value as! MD2Boolean).isSet() {
            widgetElement.setOn((value as! MD2Boolean).platformValue!, animated: false)
        } else {
            widgetElement.setOn(false, animated: false)
        }
        
        widgetElement.tag = widgetId.rawValue
        widgetElement.addTarget(self, action: "onUpdate", forControlEvents: UIControlEvents.ValueChanged)
        
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
            height: MD2ViewConfig.DIMENSION_SWITCH_HEIGHT)
        
        // Add gutter
        self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
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
    
    /**
        Target for the value change event. Updates the stored value and passes it to the respective widget wrapper which will process the value, e.g. applying validators and firing further events.
    */
    @objc
    func onUpdate() {
        self.value = MD2Boolean(self.widgetElement.on)
        MD2WidgetRegistry.instance.getWidget(widgetId)?.setValue(self.value)
    }
    
    /**
        Update the view element after its value was changed externally.
    */
    func updateElement() {
        // Update element
        if (self.value as! MD2Boolean).isSet() {
            self.widgetElement.on = ((self.value as! MD2Boolean).platformValue! as Bool)
        }
    }
    
}