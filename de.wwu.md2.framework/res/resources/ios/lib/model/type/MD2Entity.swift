//
//  MD2Entity.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for MD2 entity data types.
protocol MD2Entity: MD2Type {
    
    /// The internal value of the entity object, set when the data store creates an Id after first saving the object.
    var internalId: MD2Integer { get set }
    
    /// Key-value list of contained attributes.
    var containedTypes : Dictionary<String, MD2Type> { get set }
    
    /// Empty initializer is required.
    init()
    
    /**
        Retrieve an attribute value.

        :param: attribute The attribute name.

        :returns: The attribute value if found.
    */
    func get(attribute: String) -> MD2Type?
    
    /**
        Set an attribute value.

        :param: attribute The attribute name.
        :param: value The value to set.
    */
    func set(attribute: String, value: MD2Type)
    
}