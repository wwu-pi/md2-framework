//
//  MD2GridLayoutPane.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// A grid layout container for view elements.
class MD2GridLayoutPane: MD2Layout {
    
    /// Unique widget identification.
    let widgetId: MD2WidgetMapping
    
    /// List of contained widgets.
    var widgets: Array<MD2Widget> = []
    
    /// Number of columns in the grid.
    var columns: MD2Integer?
    
    /// Number of rows in the grid.
    var rows: MD2Integer?
    
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
    }
    
    /**
        Render the view element, i.e. specifying the position and appearance of all contaiend widgets.
    
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
    
    /**
        Calculate the dimensions of all contained widget elements based on the available bounds. The occupied space of the container is returned.
    
        *NOTICE* The occupied space may surpass the bounds (and thus the visible screen), if the height of the element is not sufficient. This is not a problem as the screen will scroll automatically.
    
        *NOTICE* The occupied space usually differs from the dimensions property as it refers to the *outer* dimensions in contrast to the dimensions property referring to *inner* dimensions. The difference represents the gutter included in the widget positioning process.
    
        :param: bounds The available screen space.
    
        :returns: The occupied outer dimensions of the container.
    */
    func calculateDimensions(bounds: MD2Dimension) -> MD2Dimension {
        // Set own dimensions
        dimensions = bounds
        
        let numUiElements = widgets.count
        
        if columns?.isSet() == true && rows?.isSet() == true {
            // All specified, nothing to do
            
        } else if columns?.isSet() == true {
            rows = MD2Integer(numUiElements / columns!.platformValue!)
            
        } else if rows?.isSet() == true {
            columns = MD2Integer(numUiElements / rows!.platformValue!)
            
        } else { // Nothing set, set both to 1
            columns = MD2Integer(1)
            rows = MD2Integer(1)
            
        }
        
        var currentY = bounds.y
        let columnWidth = bounds.width / Float(columns!.platformValue!)
        
        for var currentRow = 0; currentRow < rows!.platformValue!; currentRow++ {
            var maxHeight: Float = 0.0
            
            // Strict calculation of cell maximum sizes
            // let rowHeight = bounds.height / Float(rows!.platformValue!)
            // Allow different row height
            let rowHeight = bounds.y + bounds.height - currentY
            
            for var currentColumn = 0; currentColumn < columns!.platformValue!; currentColumn++ {
                let subDimensions = MD2Dimension(
                    x: bounds.x + Float(currentColumn) * columnWidth,
                    y: currentY,
                    width: columnWidth,
                    height: rowHeight)
                
                // Avoid problems when rows/columns are not completely filled
                if (currentRow * columns!.platformValue!) + currentColumn < widgets.count {
                    let acceptedDimension = widgets[(currentRow * columns!.platformValue!) + currentColumn].calculateDimensions(subDimensions)
                
                    if acceptedDimension.height > maxHeight {
                        maxHeight = acceptedDimension.height
                    }
                }
            }
            
            // Prepare next row
            currentY += maxHeight
        }
        
        return MD2Dimension(
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: currentY - bounds.y)
    }
    
    /// Enable all contained elements.
    func enable() {
        // Pass order to sub-elements
        for widget in widgets {
            widget.enable()
        }
    }
    
    /// Disable all contained elements.
    func disable() {
        // Pass order to sub-elements
        for widget in widgets {
            widget.disable()
        }
    }
    
}