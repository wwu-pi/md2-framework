//
//  MD2FlowLayoutPane.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 28.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A flow layout container for view elements.
class MD2FlowLayoutPane: MD2Layout {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping

    /// List of contained widgets.
    var widgets: Array<MD2Widget> = []
    
    /// Orientation of the layout flow.
    var orientation: Orientation
    
    /// If used within a tabbed container: The tab title.
    var tabTitle: MD2String?
    
    /// If used within a tabbed container: The tab icon.
    var tabIcon: MD2String?
    
    /// Inner dimensions of the screen occupied by the widget (i.e. surrounding all contained widgets).
    var dimensions: MD2Dimension?
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float?
    
    /**
        Default initializer.
    
        :param: widgetId Widget identifier
    */
    init(widgetId: MD2WidgetMapping) {
        self.widgetId = widgetId
        
        // Default
        self.orientation = Orientation.Horizontal
    }
    
    /**
        Render the view element, i.e. specifying the position and appearance of all contained widgets.
    
        :param: view The surrounding view element.
        :param: controller The responsible view controller.
    */
    func render(view: UIView, controller: UIViewController) {
        // Render sub-elements
        for widget in widgets {
            widget.render(view, controller: controller)
        }
    }
    
    /**
        Add a view elements to the list of contained view elements.
    
        :param: widget The view element to add.
    */
    func addWidget(widget: MD2Widget) {
        widgets.append(widget)
    }
    
    /// Enumeration of the flow orientation (vertical or horizontal).
    enum Orientation {
        case Vertical, Horizontal
    }
    
    /**
        Calculate the dimensions of all contained widget elements based on the available bounds. The occupied space of the container is returned.
    
        *NOTICE* The occupied space may surpass the bounds (and thus the visible screen), if the height of the element is not sufficient. This is not a problem as the screen will scroll automatically.
    
        *NOTICE* The occupied space usually differs from the dimensions property as it refers to the *outer* dimensions in contrast to the dimensions property referring to *inner* dimensions. The difference represents the gutter included in the widget positioning process.
    
        :param: bounds The available screen space.
    
        :returns: The occupied outer dimensions of the container.
    */
    func calculateDimensions(bounds: MD2Dimension) -> MD2Dimension {
        let numUiElements = widgets.count
        
        if orientation == Orientation.Horizontal {
            // Check that all specified widths do not surpass 100%
            var sum: Float = 0.0
            var numNonSpecifiedWidths = 0
            for widget in widgets {
                if let _ = widget.width {
                    sum += widget.width!
                } else {
                    sum += 0.1 // Minimum 10% for an element if not explicitly specified
                    numNonSpecifiedWidths++
                }
            }
            
            // Capture information on the actual dimensions
            var maxHeight: Float = 0.0
            var currentX = bounds.x
            
            for var currentElem = 0; currentElem < numUiElements; currentElem++ {
                var subDimensions: MD2Dimension = MD2Dimension()
                
                if sum > 1.0 {
                    // Reduce overall sizes if widths are too large
                    let multiplier: Float = 1.0 / sum
                    
                    subDimensions = MD2Dimension(
                        x: currentX,
                        y: bounds.y,
                        // Available width * (specified width OR min percentage) * multiplier 
                        width: (widgets[currentElem].width != nil) ? bounds.width * widgets[currentElem].width! * multiplier : bounds.width * 0.1 * multiplier,
                        height: bounds.height)
                } else {
                    subDimensions = MD2Dimension(
                        x: currentX,
                        y: bounds.y,
                        // Available width * (specified width OR equal proportion of remaining space)
                        width: (widgets[currentElem].width != nil) ? bounds.width * widgets[currentElem].width! : (bounds.width - (currentX - bounds.x)) / Float(numNonSpecifiedWidths),
                        height: bounds.height)
                    
                    numNonSpecifiedWidths--
                }
                
                // println(widgets[currentElem].widgetId.description + ": " + subDimensions.toString())
                let acceptedDimensions = widgets[currentElem].calculateDimensions(subDimensions)
                
                if maxHeight < acceptedDimensions.height {
                    maxHeight = acceptedDimensions.height
                }
                    
                if currentX < acceptedDimensions.x + acceptedDimensions.width {
                    currentX = acceptedDimensions.x + acceptedDimensions.width
                }
                
            }
            
            return MD2Dimension(
                x: bounds.x,
                y: bounds.y,
                width: currentX - bounds.x,
                height: maxHeight)
            
        } else if orientation == Orientation.Vertical {
            // Capture information on the actual dimensions
            var maxWidth: Float = 0.0
            var currentY = bounds.y
            
            for var currentElem = 0; currentElem < numUiElements; currentElem++ {
                let subDimensions = MD2Dimension(
                    x: bounds.x,
                    y: currentY,
                    width: bounds.width,
                    // Remaining height
                    height: (bounds.height - (currentY - bounds.y)))
                
                let acceptedDimensions = widgets[currentElem].calculateDimensions(subDimensions)

                if maxWidth < acceptedDimensions.width {
                    maxWidth = acceptedDimensions.width
                }
                
                if currentY < acceptedDimensions.y + acceptedDimensions.height {
                    currentY = acceptedDimensions.y + acceptedDimensions.height
                }
                
                // println(widgets[currentElem].widgetId.description + ": " + subDimensions.toString())
            }
            
            return MD2Dimension(
                x: bounds.x,
                y: bounds.y,
                width: maxWidth,
                height: currentY - bounds.y)
        }
        
        return MD2Dimension()
        
        /* Naive equi-sized calculation
        // Set own dimensions
        dimensions = bounds
        
        let numUiElements = widgets.count
        
        // Calculate individual positions
        for var currentElem = 0; currentElem < numUiElements; currentElem++ {
            var subDimensions = Dimension()
            
            if orientation == Orientation.Horizontal {
                subDimensions = Dimension(
                    x: bounds.x + Float(currentElem) * (bounds.width / Float(numUiElements)),
                    y: bounds.y,
                    width: bounds.width / Float(numUiElements),
                    height: bounds.height)
            } else {
                subDimensions = Dimension(
                    x: bounds.x,
                    y: bounds.y + Float(currentElem) * (bounds.height / Float(numUiElements)),
                    width: bounds.width,
                    height: bounds.height / Float(numUiElements))
            }
            
            println(widgets[currentElem].widgetId.description + ": " + subDimensions.toString())
            widgets[currentElem].calculateDimensions(subDimensions)
        }
        
        return dimensions!
        */
    }
    
    /// Enable all contained view elements.
    func enable() {
        // Pass order to sub-elements
        for widget in widgets {
            widget.enable()
        }
    }
    
    /// Disable all contained view elements.
    func disable() {
        // Pass order to sub-elements
        for widget in widgets {
            widget.disable()
        }
    }
    
}