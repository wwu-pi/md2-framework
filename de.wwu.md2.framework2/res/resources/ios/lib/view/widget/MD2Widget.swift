//
//  MD2Widget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 28.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Interface for widgets.
protocol MD2Widget: class {
    
    /// Unique widget identification.
    var widgetId: MD2WidgetMapping { get }
    
    /// Inner dimensions of the screen occupied by the widget.
    var dimensions: MD2Dimension? { get set }
    
    /// Width of the widget as specified by the model (percentage of the availale width).
    var width: Float? { get }
    
    /**
        Render the view element, i.e. specifying the position and appearance of the widget.
    
        :param: view The surrounding view element.
        :param: controller The responsible view controller.
    */
    func render(view: UIView, controller: UIViewController)

    /**
        Calculate the dimensions of the widget based on the available bounds. The occupied space of the widget is returned.
    
        *NOTICE* The occupied space may surpass the bounds (and thus the visible screen), if the height of the element is not sufficient. This is not a problem as the screen will scroll automatically.
    
        *NOTICE* The occupied space usually differs from the dimensions property as it refers to the *outer* dimensions in contrast to the dimensions property referring to *inner* dimensions. The difference represents the gutter included in the widget positioning process.
    
        :param: bounds The available screen space.
    
        :returns: The occupied outer dimensions of the widget.
    */
    func calculateDimensions(bounds: MD2Dimension) -> MD2Dimension
    
    /// Enable the view element.
    func enable()
    
    /// Disable the view element.
    func disable()

}