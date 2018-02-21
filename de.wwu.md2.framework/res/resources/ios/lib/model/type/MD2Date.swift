//
//  MD2Date.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

/// MD2 data type for date values.
class MD2Date: MD2TemporalType {
    
    /// Computed property that returns the specific platformValue type to the generic property defined in the protocol.
    var value: Any? {
        get {
            return platformValue
        }
    }

    /// Contained platform type.
    var platformValue: NSDate?
    
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
            var dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
            dateFormatter.dateFormat = MD2ModelConfig.STRING_FORMAT_DATE
            
            platformValue = dateFormatter.dateFromString(value.platformValue!)
        }
    }
    
    /**
        Initializer to create an MD2 data type from a native string value.
    
        :param: value The string representation.
    */
    convenience init(_ value: String) {
        self.init(MD2String(value))
    }
    
    /**
        Initialitzer to create an MD2 data type from another MD2Date value.
    
        :param: md2Date The MD2 data type to copy.
    */
    init(_ md2Date: MD2Date) {
        platformValue = md2Date.platformValue
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
    func gt(value: MD2TemporalType) -> Bool {
        if value is MD2Date || value is MD2DateTime {
            return isSet()
                && value.isSet()
                && platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedDescending // receiver value is after other value
        }
        
        // Cannot compare date with time
        return false
    }
    
    /**
        Greater-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is greater or equal to the parameter value.
    */
    func gte(value: MD2TemporalType) -> Bool {
        if value is MD2Date {
            return isSet()
                && value.isSet()
                && (platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedDescending ||
                    platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedSame)
        } else if value is MD2DateTime {
            return isSet()
                && value.isSet()
                && (platformValue!.compare((value as! MD2DateTime).platformValue!) == NSComparisonResult.OrderedDescending ||
                    platformValue!.compare((value as! MD2DateTime).platformValue!) == NSComparisonResult.OrderedSame)
        }
        
        // Cannot compare date with time
        return false
    }
    
    /**
        Lower-than comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower than the parameter value.
    */
    func lt(value: MD2TemporalType) -> Bool {
        if value is MD2Date {
            return isSet() && value.isSet()
                && platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedAscending
        } else if value is MD2DateTime {
            return isSet() && value.isSet()
                && platformValue!.compare((value as! MD2DateTime).platformValue!) == NSComparisonResult.OrderedAscending
        }
        
        // Cannot compare date with time
        return false
    }
    
    /**
        Lower-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower or equal to the parameter value.
    */
    func lte(value: MD2TemporalType) -> Bool {
        if value is MD2Date {
            return isSet()
                && value.isSet()
                && (platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedAscending ||
                    platformValue!.compare((value as! MD2Date).platformValue!) == NSComparisonResult.OrderedSame)
        } else if value is MD2DateTime {
            return isSet()
                && value.isSet()
                && (platformValue!.compare((value as! MD2DateTime).platformValue!) == NSComparisonResult.OrderedAscending ||
                    platformValue!.compare((value as! MD2DateTime).platformValue!) == NSComparisonResult.OrderedSame)
        }
        
        // Cannot compare date with time
        return false
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return MD2Date(self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
        if platformValue == nil {
            return ""
        }
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        dateFormatter.dateFormat = MD2ModelConfig.STRING_FORMAT_DATE
        
        return dateFormatter.stringFromDate(platformValue!)
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if value is MD2TemporalType {
            return gte((value as! MD2TemporalType)) && lte((value as! MD2TemporalType))
        } else {
            return toString() == value.toString()
        }
    }
    
}