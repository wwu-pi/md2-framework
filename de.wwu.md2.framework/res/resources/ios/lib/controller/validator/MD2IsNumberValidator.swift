//
//  MD2IsNumberValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a numeric value.
*/
class MD2IsNumberValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("This value must be a valid number!")
        }
    }
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
    */
    init(identifier: MD2String, message: (() -> MD2String)?) {
        self.identifier = identifier
        self.message = message
    }
    
    /**
        Validate a value.
    
        :param: value The value to check.
    
        :return: Validation result
    */
    func isValid(value: MD2Type) -> Bool {
        if value is MD2NumericType {
            return true
        }
        
        // Try to parse
        if MD2Float(MD2String(value.toString())).toString() == value.toString()
            || MD2Integer(MD2String(value.toString())).toString() == value.toString() {
                return true
        }
        
        return false
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