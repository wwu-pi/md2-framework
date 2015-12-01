//
//  MD2RegExValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check values against a regular expression.
*/
class MD2RegExValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("This value must match the expected pattern!")
        }
    }
    
    /// The regular expression pattern to match against.
    let regEx: MD2RegEx
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: regEx The regular expression matching a valid string.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, regEx: MD2String) {
        self.identifier = identifier
        self.message = message
        self.regEx = MD2RegEx(pattern: regEx)
    }
    
    /**
        Validate a value.
    
        :param: value The value to check.
    
        :return: Validation result
    */
    func isValid(value: MD2Type) -> Bool {
        if value is MD2String {
            return regEx.test(value as! MD2String)
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