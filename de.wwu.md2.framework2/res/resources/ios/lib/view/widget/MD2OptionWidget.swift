//
//  MD2OptionWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// An option selector view element. Rendered as text field with alternative wheel selection input mechanism.
class MD2OptionWidget: NSObject, MD2SingleWidget, MD2AssistedWidget, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    
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
    
    /// The native UI control.
    var widgetElement: UITextField
    
    /// The caption for the view element.
    var label: MD2String?
    
    /// The tooltip text to display for assistance.
    var tooltip: MD2String?
    
    /// The list of values that can be selected.
    var options: Array<String>? = []
    
    /// The picker view element opened instead of the virtual keyboard.
    var picker: UIPickerView = UIPickerView()
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        self.value = MD2String()
        self.widgetElement = UITextField()
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
        widgetElement.addTarget(self, action: "onUpdate", forControlEvents: UIControlEvents.ValueChanged)
        
        // Set styling
        widgetElement.backgroundColor = UIColor(rgba: "#fff")
        widgetElement.borderStyle = UITextBorderStyle.RoundedRect
        widgetElement.font = UIFont(name: MD2ViewConfig.FONT_NAME.rawValue, size: CGFloat(MD2ViewConfig.FONT_SIZE))
        
        // Add to surrounding view
        view.addSubview(widgetElement)
        
        // Picker to select value
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor(rgba: "#dfdfdf")
        self.widgetElement.inputView = picker
        
        // Add tap recognizer on picker field manually
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "pickerViewTapped")
        tapRecognizer.delegate = self
        self.picker.addGestureRecognizer(tapRecognizer)
        
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
            height: MD2ViewConfig.DIMENSION_OPTION_HEIGHT)
        
        // Add gutter
        self.dimensions = MD2UIUtil.innerDimensionsWithGutter(outerDimensions)
        widgetElement.frame = MD2UIUtil.dimensionToCGRect(dimensions!)
        
        return outerDimensions
    }

    /**
        Data source method: Specify the number of wheels. Value selector only has one.
    
        :param: colorPicker The picker element.
    
        :return: Option selector only has one wheel.
    */
    @objc
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }
    
    /**
        Data source method: Get the total number of rows in the wheel.
        
        :param: pickerView The picker element.
        :param: numberOfRowsInComponent The number of rows in a wheel (widget has only one).
    
        :return: The number of values.
    */
    @objc
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options!.count
    }
    
    /**
        Delegate method to update the picker view element with the respective value.
        
        :param: pickerView The picker element.
        :param: titleForRow Index of the selected row.
        :param: forComponent Index of the selected wheel (only has one).
    
        :returns: The string value to display for this item.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return options?[row] ?? ""
    }
    
    /**
        Synchronize text field with input wheels.
    
        :param: pickerView The picker element.
        :param: didSelectRow Index of the selected row.
        :param: inComponent Index of the selected wheel (only has one).
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update text field on scrolling
        self.widgetElement.text = options![row]
    }
    
    /**
        Action target method to capture single tap on picker view element and close the input wheel.
    */
    func pickerViewTapped() {
        self.widgetElement.text = options![self.picker.selectedRowInComponent(0)]
        onUpdate()
        
        // Hide picker element
        self.widgetElement.resignFirstResponder()
    }

    /**
        Gesture recognizer to intercept taps. If some other delegate tries to get the tap first, allow simultaneous processing.
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        
        var defaultRowIndex = find(options!, self.value.toString())
        if(defaultRowIndex == nil) { defaultRowIndex = 0 }
        self.picker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
    }
    
}