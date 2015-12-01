//
//  MD2DateDateTimeValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a given datetime range.
*/
class MD2DateTimeRangeValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("The date and time must be between \(min.toString()) and \(max.toString())!")
        }
    }
    
    /// Minimum allowed datetime.
    let min: MD2DateTime
    
    /// Maximum allowed datetime.
    let max: MD2DateTime
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: min The minimum value of a valid datetime.
        :param: max The maximum value of a valid datetime.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, min: MD2DateTime, max: MD2DateTime) {
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
        if value is MD2DateTime
            && (value as! MD2DateTime).gte(min)
            && (value as! MD2DateTime).lte(max) {
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