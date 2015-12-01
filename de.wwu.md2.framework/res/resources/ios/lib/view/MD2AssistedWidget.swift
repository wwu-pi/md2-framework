//
//  MD2AssistedWidget.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 06.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for assisted widgets that can show tooltip information.
protocol MD2AssistedWidget {
    
    /// The tooltip text to display for assistance.
    var tooltip: MD2String? { get }
    
}