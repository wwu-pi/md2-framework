//
//  MD2StylableWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for stylable widgets
protocol MD2StylableWidget {
    
    /// The color as hex string.
    var color: MD2String? { get set }
    
    /// The font size as multiplicatve scaling factor (similar to 'em' in CSS).
    var fontSize: MD2Float? { get set }
    
    /// The text style.
    var textStyle: MD2WidgetTextStyle { get set }
    
}