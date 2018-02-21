//
//  MD2Float.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

/// MD2 data type for float values.
class MD2Float: MD2NumericType {
    
    /// Computed property that returns the specific platformValue type to the generic property defined in the protocol.
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    /// Contained platform type.
    var platformValue: Float?
    
    /// Empty initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Required initializer to deserialize values from a string representation.
    
        :param: value The string representation.
    */
    required init(_ value: MD2String) {
        if value.isSet() && !value.equals(MD2String("")) {
            platformValue = (value.platformValue! as NSString).floatValue
        }
    }
    
    /**
        Initializer to create an MD2 data type from a native float value.
    
        :param: value The float representation.
    */
    init(_ value: Float) {
        platformValue = value
    }
    
    /**
        Initialitzer to create an MD2 data type from another MD2Float value.
    
        :param: md2Float The MD2 data type to copy.
    */
    init(_ md2Float: MD2Float) {
        platformValue = md2Float.platformValue
    }
    
    /**
        Determine whether the represented value is empty/unset or filled.
    
        :returns: Whether the value is empty or not.
    */
    func isSet() -> Bool {
        return platformValue != nil
    }
    
    /**
        Greater-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is greater or equal to the parameter value.
    */
    func gt(value: MD2NumericType) -> Bool {
        if value is MD2Integer && isSet() && value.isSet() {
            return platformValue! - Float((value as! MD2Integer).platformValue!) > MD2ModelConfig.FLOATING_ERROR
        } else if value is MD2Float && isSet() && value.isSet() {
            return platformValue! - (value as! MD2Float).platformValue! > MD2ModelConfig.FLOATING_ERROR
        }
        return false
    }
    
    /**
        Greater-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is greater or equal to the parameter value.
    */
    func gte(value: MD2NumericType) -> Bool {
        return gt(value) || equals(value)
    }
    
    /**
        Lower-than comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower than the parameter value.
    */
    func lt(value: MD2NumericType) -> Bool {
        if value is MD2Integer && isSet() && value.isSet() {
            return platformValue! - Float((value as! MD2Integer).platformValue!) < -1 * MD2ModelConfig.FLOATING_ERROR
        } else if value is MD2Float && isSet() && value.isSet() {
            return platformValue! - (value as! MD2Float).platformValue! < -1 *  MD2ModelConfig.FLOATING_ERROR
        }
        return false
    }
    
    /**
        Lower-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower or equal to the parameter value.
    */
    func lte(value: MD2NumericType) -> Bool {
        return lt(value) || equals(value)
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return MD2Float(self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        return platformValue != nil ? platformValue!.description : ""
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if value is MD2Integer && isSet() && (value as! MD2Integer).isSet() {
            return abs(platformValue! - Float((value as! MD2Integer).platformValue!)) < MD2ModelConfig.FLOATING_ERROR
        } else if value is MD2Float && isSet() && (value as! MD2Float).isSet() {
            return abs(platformValue! - Float((value as! MD2Float).platformValue!)) < MD2ModelConfig.FLOATING_ERROR
        }
        return self.toString() == value.toString()
    }
    
}