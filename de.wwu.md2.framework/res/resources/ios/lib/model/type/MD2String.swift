//
//  MD2String.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// MD2 data type for string values.
class MD2String: MD2DataType {
    
    /// Computed property that returns the specific platformValue type to the generic property defined in the protocol.
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    /// Contained platform type.
    var platformValue: String?
    
    /// Empty initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Required initializer to deserialize values from a string representation.
    
        :param: value The string representation.
    */
    required init(_ value: MD2String) {
        if value.isSet() {
            platformValue = value.platformValue!
        }
    }
    
    /**
        Initializer to create an MD2 data type from a native string value.
    
        :param: value The string representation.
    */
    init(_ value: String) {
        platformValue = value
    }
    
    /**
        Determine whether the represented value is empty/unset or filled.
    
        :returns: Whether the value is empty or not.
    */
    func isSet() -> Bool {
        return platformValue != nil
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return MD2String(self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        if platformValue == nil {
            return ""
        } else {
            return platformValue!
        }
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if platformValue == nil {
            return "" == value.toString()
        }
        
        return platformValue == value.toString()
    }
}