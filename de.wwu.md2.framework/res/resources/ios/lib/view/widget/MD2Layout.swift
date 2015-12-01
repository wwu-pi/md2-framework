//
//  MD2Layout.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 28.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for MD2 layout containers.
protocol MD2Layout: MD2Widget {
    
    /// An ordered list of contained view elements.
    var widgets: Array<MD2Widget> { get set }
    
    /**
        Add a view elements to the list of contained view elements.

        :param: widget The view element to add.
    */
    func addWidget(widget: MD2Widget)
    
}