//
//  MD2Type.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for all MD2 data types
protocol MD2Type: AnyObject {
    
    /**
        Clone an object.

        :returns: A copy of the object.
    */
    func clone() -> MD2Type
    
    /**
        Get a string representation of the object.

        :returns: The string representation
    */
    func toString() -> String
    
    /**
        Compare two objects based on their content (not just comparing references).

        :param: value The object to compare with.

        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool
    
}