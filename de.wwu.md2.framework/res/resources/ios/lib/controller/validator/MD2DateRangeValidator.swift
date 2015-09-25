//
//  MD2DateRangeValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a given date range.
*/
class MD2DateRangeValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("The date must be between \(min.toString()) and \(max.toString())!")
        }
    }
    
    /// Minimum allowed date.
    let min: MD2Date
    
    /// Maximum allowed date.
    let max: MD2Date
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: min The minimum date of a valid date.
        :param: max The maximum date of a valid date.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, min: MD2Date, max: MD2Date) {
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
        if value is MD2Date
            && (value as! MD2Date).gte(min)
            && (value as! MD2Date).lte(max) {
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