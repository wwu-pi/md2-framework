//
//  MD2TextFieldWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 29.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A regular text field widget.
class MD2TextFieldWidget: NSObject, MD2SingleWidget, MD2AssistedWidget, UITextFieldDelegate {
    
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
    
    /// Placeholder text for empty text fields.
    var placeholder: MD2String?
    
    /// The native UI control.
    var widgetElement: UITextField
    
    /// Text field caption.
    var label: MD2String?
    
    /// The tooltip text to display for assistance.
    var tooltip: MD2String?
    
    /// The tooltip UI control dimensions.
    var tooltipDimensions: MD2Dimension?
    
    /// Text field type, e.g. single-line, multi-line, ...
    var type: TextField = TextField.Standard
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /// The button widget that represents the tooltip control.
    var infoButton: MD2ButtonWidget
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
        self.widgetElement = UITextField()
        self.infoButton = MD2ButtonWidget(widgetId: self.widgetId)
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
        widgetElement.placeholder = placeholder?.platformValue
        updateElement()
        
        widgetElement.tag = widgetId.rawValue
        widgetElement.addTarget(self, action: "onUpdate", forControlEvents: (UIControlEvents.EditingDidEnd | UIControlEvents.EditingDidEndOnExit))
        
        // Set styling
        widgetElement.backgroundColor = UIColor.whiteColor()
        widgetElement.borderStyle = UITextBorderStyle.RoundedRect
        widgetElement.font = UIFont(name: MD2ViewConfig.FONT_NAME.rawValue, size: CGFloat(MD2ViewConfig.FONT_SIZE))
        
        // Add to surrounding view
        widgetElement.delegate = self
        view.addSubview(widgetElement)
        
        // If tooltip info is available show info button
        if tooltip != nil && tooltip!.isSet() && !tooltip!.equals(MD2String("")) {
            infoButton.buttonType = UIButtonType.InfoLight
            infoButton.dimensions = self.tooltipDimensions
            infoButton.render(view, controller: controller)
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
        var outerDimensions: MD2Dimension = bounds
        
        // If tooltip info is available show info button
        if tooltip != nil && tooltip!.isSet() && !tooltip!.equals(MD2String("")) {
            outerDimensions = MD2Dimension(
                x: bounds.x,
                y: bounds.y,
                width: bounds.width,
                height: MD2ViewConfig.DIMENSION_TEXTFIELD_HEIGHT)
            
            var textFieldDimensions = outerDimensions - MD2Dimension(
                x: Float(0.0),
                y: Float(0.0),
                width: Float(MD2ViewConfig.TOOLTIP_WIDTH),
                height: Float(0.0))
            
            // Add gutter
            self.dimensions = MD2UIUtil.innerDimensionsWithGutter(textFieldDimensions)
            widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
            
            self.tooltipDimensions = MD2Dimension(
                x: (outerDimensions.x + outerDimensions.width) - Float(MD2ViewConfig.TOOLTIP_WIDTH) - MD2ViewConfig.GUTTER / 2,
                // center vertically
                y: textFieldDimensions.y + (textFieldDimensions.height - MD2ViewConfig.TOOLTIP_WIDTH) / 2,
                width: MD2ViewConfig.TOOLTIP_WIDTH,
                height: MD2ViewConfig.TOOLTIP_WIDTH)
            infoButton.widgetElement?.frame = MD2UIUtil.dimensionToCGRect(tooltipDimensions!)
            
            return outerDimensions
            
        } else {
            // Normal full-width field
            outerDimensions = MD2Dimension(
                x: bounds.x,
                y: bounds.y,
                width: bounds.width,
                height: MD2ViewConfig.DIMENSION_TEXTFIELD_HEIGHT)
            
            // Add gutter
            self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
            widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
            
            return outerDimensions
        }
    }
    
    /**
        Enumeration for all possible text field types.

        *TODO* Currently, only standard text field (single-line) are supported).
    */
    enum TextField {
        case Standard
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.widgetElement.resignFirstResponder()
        return true
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
    func onUpdate() {
        self.value = MD2String(self.widgetElement.text)
        MD2WidgetRegistry.instance.getWidget(widgetId)?.setValue(self.value)
    }
    
    /**
        Update the view element after its value was changed externally.
    */
    func updateElement() {
        self.widgetElement.text = value.toString()
    }
    
}
