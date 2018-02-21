//
//  MD2SingleWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 28.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for non-container view elements.
protocol MD2SingleWidget: MD2Widget {
    
    /// The (output or input) value of the view element.
    var value: MD2Type { get set }

}