//
//  MD2TimeRangeValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a given time range.
*/
class MD2TimeRangeValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("The time must be between \(min.toString()) and \(max.toString())!")
        }
    }
    
    /// Minimum allowed time.
    let min: MD2Time
    
    /// Maximum allowed time.
    let max: MD2Time
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: min The minimum value of a valid time.
        :param: max The maximum value of a valid time.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, min: MD2Time, max: MD2Time) {
        self.identifier = identifier
        self.message = message
        self.min = min
        self.max = max
    }
    
    /**
        Validate a value.
    
        :param: value The value to check.
    
        :return: Validation result
    */
    func isValid(value: MD2Type) -> Bool {
        if value is MD2Time
            && (value as! MD2Time).gte(min)
            && (value as! MD2Time).lte(max) {
                return true
        } else {
            return false
        }
    }
    
    /**
        Return the message to display on wrong validation.
        Use custom method if set or else use default message.
    */
    func getMessage() -> MD2String {
        if let _ = message {
            return message!()
        } else  {
            return defaultMessage
        }
    }
    
}