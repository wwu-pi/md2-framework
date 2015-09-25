//
//  MD2StringRangeValidator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Validator to check for a given string range.
*/
class MD2StringRangeValidator: MD2Validator {
    
    /// Unique identification string.
    let identifier: MD2String
    
    /// Custom message to display.
    var message: (() -> MD2String)?
    
    /// Default message to display.
    var defaultMessage: MD2String {
        get {
            return MD2String("This value must be between \(minLength) and \(maxLength) characters long!")
        }
    }
    
    /// The minimum allowed length.
    var minLength: MD2Integer
    
    /// The maximum allowed length.
    var maxLength: MD2Integer
    
    /**
        Default initializer.
    
        :param: identifier The unique validator identifier.
        :param: message Closure of the custom method to display.
        :param: minLength The minimum length of a valid string.
        :param: maxLength The maximum langth of a valid string.
    */
    init(identifier: MD2String, message: (() -> MD2String)?, minLength: MD2Integer, maxLength: MD2Integer) {
        self.identifier = identifier
        self.message = message
        self.minLength = minLength
        self.maxLength = maxLength
    }
    
    /**
        Validate a value.
    
        :param: value The value to check.
    
        :return: Validation result
    */
    func isValid(value: MD2Type) -> Bool {
        if !(value is MD2String)
            || !((value as! MD2String).isSet())
            || !(maxLength.isSet()) {
                return false
        }
        
        // Set default minimum length
        if minLength.isSet() == false {
            minLength.platformValue = 0
        }
        
        let stringValue = (value as! MD2String).platformValue!
        
        if count(stringValue) >= minLength.platformValue!
           && count(stringValue) <= maxLength.platformValue! {
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