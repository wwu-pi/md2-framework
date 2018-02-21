//
//  MD2Integer.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

/// MD2 data type for integer values.
class MD2Integer: MD2NumericType {
    
    /// Computed property that returns the specific platformValue type to the generic property defined in the protocol.
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    /// Contained platform type.
    var platformValue: Int?
    
    /// Empty initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Initializer to create an MD2 data type from a native integer value.
    
        :param: value The integer representation.
    */
    init(_ value : Int){
        if value > 0 {
            platformValue = value
        }
    }
    
    /**
        Required initializer to deserialize values from a string representation.
    
        :param: value The string representation.
    */
    required init(_ value: MD2String) {
        if value.isSet() && !value.equals(MD2String("")) {
            platformValue = (value.platformValue! as NSString).integerValue
        }
    }
    
    /**
        Initialitzer to create an MD2 data type from another MD2Integer value.
    
        :param: md2Integer The MD2 data type to copy.
    */
    init(_ md2Integer: MD2Integer) {
        platformValue = md2Integer.platformValue
    }
    
    /**
        Determine whether the represented value is empty/unset or filled.
    
        :returns: Whether the value is empty or not.
    */
    func isSet() -> Bool {
        return platformValue != nil
    }
    
    /**
        Greater-than comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is greater than the parameter value.
    */
    func gt(value: MD2NumericType) -> Bool {
        if value is MD2Integer && isSet() && value.isSet() {
            return platformValue! > (value as! MD2Integer).platformValue!
        } else if value is MD2Float && isSet() && value.isSet() {
            return platformValue! > Int((value as! MD2Float).platformValue!)
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
            return platformValue! < (value as! MD2Integer).platformValue!
        } else if value is MD2Float && isSet() && value.isSet() {
            return platformValue! < Int((value as! MD2Float).platformValue!)
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
        return MD2Integer(self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        if !isSet() {
            return ""
        }
        
        return String(platformValue!)
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if value is MD2Integer && isSet() && (value as! MD2Integer).isSet() {
            return platformValue == (value as! MD2Integer).platformValue
        } else if value is MD2Float && isSet() && (value as! MD2Float).isSet() {
            return platformValue == Int((value as! MD2Float).platformValue!)
        }
        return self.toString() == value.toString()
    }

}