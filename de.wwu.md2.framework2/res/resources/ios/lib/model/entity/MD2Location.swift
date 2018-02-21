//
//  MD2Location.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Entity class representing the location.
class MD2Location: MD2Entity {
    
    /// The internal value of the entity object, set when the data store creates an Id after first saving the object.
    var internalId: MD2Integer = MD2Integer()
    
    /// Key-value list of contained attributes.
    var containedTypes: Dictionary<String,MD2Type> = [:]
    
    /// Empty initializer is required.
    required init() {
        // Initialize location fields
        containedTypes["longitude"] = MD2Float(0.0)
        containedTypes["latitude"] = MD2Float(0.0)
    }
    
    /**
        Initializer to create an object from the same data type (=copy).

        :param: md2Entity The entity to copy.
    */
    convenience init(md2Entity: MD2Location) {
        self.init()
        
        for (typeName, typeValue) in md2Entity.containedTypes {
            containedTypes[typeName] = typeValue.clone()
        }
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return MD2Location(md2Entity: self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        return "(Location: [longitude: " + containedTypes["longitude"]!.toString()
            + ", latitude: " + containedTypes["latitude"]!.toString()
            + "])"
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if !(value is MD2Location) {
            return false
        }

        var isEqual = true
        
        for (typeName, typeValue) in (value as! MD2Location).containedTypes {
            if !(containedTypes[typeName] != nil && containedTypes[typeName]!.equals(typeValue)) {
                isEqual = false
                break
            }
        }
        
        return isEqual
    }
    
    /**
        Retrieve an attribute value.
    
        :param: attribute The attribute name.
    
        :returns: The attribute value if found.
    */
    func get(attribute: String) -> MD2Type? {
        return containedTypes[attribute]
    }
    
    /**
        Set an attribute value.
    
        :param: attribute The attribute name.
        :param: value The value to set.
    */
    func set(attribute: String, value: MD2Type) {
        containedTypes[attribute] = value
    }
    
}