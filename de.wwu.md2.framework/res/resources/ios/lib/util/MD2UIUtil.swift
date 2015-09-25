//
//  UIUtil.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Utility class for view-related functions
class MD2UIUtil {
    
    /**
        Transform the CGRect object of view elements to a dimension object for easier handling. 

        :param: bounds The rectangle object.
    
        :returns: The dimension object.
    */
    static func CGRectToDimension(bounds: CGRect) -> MD2Dimension {
        let dimension = MD2Dimension(
                        x: Float(bounds.origin.x),
                        y: Float(bounds.origin.y),
                        width: Float(bounds.size.width),
                        height: Float(bounds.size.height))
        
        return dimension
    }
    
    /**
        Transform the CGSize object of view elements to a dimension object for easier handling.
    
        :param: size The size object.
    
        :returns: The dimension object.
    */
    static func CGSizeToDimension(size: CGSize) -> MD2Dimension {
        let dimension = MD2Dimension(
                        x: Float(0),
                        y: Float(0),
                        width: Float(size.width),
                        height: Float(size.height))
        return dimension
    }
    
    /**
        Transform the dimension object to a CGRect object to set within a view element.

        :param: dimension The dimension object.
    
        :returns: The rectangle object.
    */
    static func dimensionToCGRect(dimension: MD2Dimension) -> CGRect {
        let rect = CGRect(x: Double(dimension.x),
                        y: Double(dimension.y),
                        width: Double(dimension.width),
                        height: Double(dimension.height))
        return rect
    }
    
    /**
        Transform the dimension object to a CGSize object.
    
        :param: dimension The dimension object.
    
        :returns: The size object.
    */
    static func dimensionToCGSize(dimension: MD2Dimension) -> CGSize {
        let size = CGSize(
            width: Double(dimension.width),
            height: Double(dimension.height))
        return size
    }
    
    /**
        Show a message in an overlay popup.

        :param: message The message to show.
        :param: title The popup title.
    */
    static func showMessage(message: String, title: String) {
        var alertView = UIAlertView()
        alertView.title = title
        alertView.addButtonWithTitle(MD2ViewConfig.TOOLTIP_BUTTON)
        alertView.message = message
        alertView.show()
    }

    /**
        Return the inner dimensions of a view element by applying the gutter margin to an outer margin.

        :param: outerDimension The outer dimension object.
    
        :returns: The inner dimension.
    */
    static func innerDimensionsWithGutter(outerDimensions: MD2Dimension) -> MD2Dimension {
        return outerDimensions + MD2Dimension(
            x: MD2ViewConfig.GUTTER,
            y: MD2ViewConfig.GUTTER,
            width: -2 * MD2ViewConfig.GUTTER,
            height: -2 * MD2ViewConfig.GUTTER)
    }
}
