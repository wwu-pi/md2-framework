//
//  MD2NotNullValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check against empty values
*/
class MD2NotNullValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String = MD2String("This value must not be empty!")
    
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
        if value.equals(MD2String("")) {
            return false
        } else {
            return true
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