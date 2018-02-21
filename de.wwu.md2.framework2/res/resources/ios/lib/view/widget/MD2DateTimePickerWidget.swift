//
//  MD2DateTimePickerWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Picker widget to select temporal types (date, datetime, time) based on the picker mode. Rendered as text field with alternative wheel selector input.
class MD2DateTimePickerWidget: NSObject, MD2SingleWidget, UIGestureRecognizerDelegate {
    
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
    
    /// The picker view element opened instead of the virtual keyboard.
    var pickerElement: UIDatePicker?
    
    /// The native UI control.
    var widgetElement: UITextField
   
    /// The picker mode to select the type of wheels to show (date, datetime or time).
    var pickerMode: UIDatePickerMode?
    
    /// Width of the widget as specified by the model (percentage of the availale width)
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
        self.widgetElement = UITextField()

        // Default
        self.pickerMode = UIDatePickerMode.DateAndTime
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
        
        // Text field to display result
        widgetElement.placeholder = MD2ViewConfig.OPTION_WIDGET_PLACEHOLDER
        
        widgetElement.tag = widgetId.rawValue
        
        // Set styling
        widgetElement.backgroundColor = UIColor(rgba: "#fff")
        widgetElement.borderStyle = UITextBorderStyle.RoundedRect
        widgetElement.font = UIFont(name: MD2ViewConfig.FONT_NAME.rawValue, size: CGFloat(MD2ViewConfig.FONT_SIZE))
        
        // Add to surrounding view
        view.addSubview(widgetElement)
        
        // Create and set value
        let pickerElement = UIDatePicker()
        pickerElement.datePickerMode = pickerMode!
        pickerElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        pickerElement.backgroundColor = UIColor(rgba: "#dfdfdf")
        
        pickerElement.tag = widgetId.rawValue
        pickerElement.addTarget(self, action: "updateTextField", forControlEvents: UIControlEvents.ValueChanged)
        
        widgetElement.inputView = pickerElement
        self.pickerElement = pickerElement
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "pickerViewTapped")
        tapRecognizer.delegate = self
        self.pickerElement!.addGestureRecognizer(tapRecognizer)
        
        // Set value
        updateElement()
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
            height: MD2ViewConfig.DIMENSION_DATE_TIME_PICKER_HEIGHT)
        
        // Add gutter
        self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
        widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        
        return outerDimensions
    }
    
    // Action method to capture single click on picker view element
    func pickerViewTapped() {
        updateTextField()
        // Hide picker element
        self.widgetElement.resignFirstResponder()
    }
    
    // Some other delegate tries to get the tap first -> allow simultaneous processing
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func updateTextField() {
        let formatter = NSDateFormatter()
        
        switch self.pickerMode! {
        case UIDatePickerMode.DateAndTime:  formatter.dateFormat = MD2ViewConfig.DATE_TIME_FORMAT
        case UIDatePickerMode.Date:         formatter.dateFormat = MD2ViewConfig.DATE_FORMAT
        case UIDatePickerMode.Time:         formatter.dateFormat = MD2ViewConfig.TIME_FORMAT
        default:                            formatter.dateFormat = MD2ViewConfig.DATE_TIME_FORMAT
        }
        
        self.widgetElement.text = formatter.stringFromDate(self.pickerElement!.date)
        
        // Update event
        self.value = MD2String(self.widgetElement.text)
        MD2WidgetRegistry.instance.getWidget(widgetId)?.setValue(self.value)
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
        Update the view element after its value was changed externally.
    */
    func updateElement() {
        self.widgetElement.text = value.toString()
        
        let formatter = NSDateFormatter()
        switch self.pickerMode! {
        case UIDatePickerMode.DateAndTime:  formatter.dateFormat = MD2ViewConfig.DATE_TIME_FORMAT
        case UIDatePickerMode.Date:         formatter.dateFormat = MD2ViewConfig.DATE_FORMAT
        case UIDatePickerMode.Time:         formatter.dateFormat = MD2ViewConfig.TIME_FORMAT
        default:                            formatter.dateFormat = MD2ViewConfig.DATE_TIME_FORMAT
        }
        
        let date: NSDate? = formatter.dateFromString(self.value.toString())
        if let _ = date {
            self.pickerElement!.setDate(date!, animated: false)
        }
    }
    
}