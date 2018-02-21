//
//  MD2Boolean.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// MD2 data type for boolean values.
class MD2Boolean: MD2DataType {
    
    /// Computed property that returns the specific platformValue type to the generic property defined in the protocol.
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    /// Contained platform type.
    var platformValue: Bool?
    
    /// Empty initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Required initializer to deserialize values from a string representation.
    
        :param: value The string representation.
    */
    required init(_ value: MD2String) {
        if value.isSet() && value.equals(MD2String("true")) {
            platformValue = true
        } else if value.isSet() && value.equals(MD2String("false")) {
            platformValue = false
        }
    }
    
    /**
        Initializer to create an MD2 data type from a native boolean value.

        :param: value The boolean representation.
    */
    init(_ value : Bool) {
        platformValue = value
    }
    
    /**
        Initialitzer to create an MD2 data type from another MD2Boolean value.

        :param: md2Boolean The MD2 data type to copy.
    */
    init(_ md2Boolean: MD2Boolean) {
        platformValue = md2Boolean.platformValue
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func isSet() -> Bool {
        return platformValue != nil
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return MD2Boolean(self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        if platformValue == nil {
            return ""
        }
        
        return platformValue == true ? "true" : "false"
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        return (value is MD2Boolean)
            && platformValue == (value as! MD2Boolean).platformValue
    }

}