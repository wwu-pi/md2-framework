//
//  MD2NumberRangeValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a given number range.
*/
class MD2NumberRangeValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("This value must be between \(min.toString()) and \(max.toString())!")
        }
    }

    /// The minimum allowed float value.
    let min: MD2Float
    
    /// The maximum allowed float value.
    let max: MD2Float
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: min The minimum value of a valid number.
        :param: max The maximum value of a valid number.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, min: MD2Float, max: MD2Float) {
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
        if value is MD2NumericType
            && (value as! MD2NumericType).gte(min)
            && (value as! MD2NumericType).lte(max) {
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