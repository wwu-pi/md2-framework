//
//  MD2Validator.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for validators.
protocol MD2Validator {
    
    /// Unique identification string.
    var identifier: MD2String { get }
    
    /// Custom message to display.
    var message: (() -> MD2String)? { get }
    
    /// Default message to display.
    var defaultMessage: MD2String { get }
    
    /**
        Validate a value.

        :param: value The value to check.

        :return: Validation result
    */
    func isValid(value: MD2Type) -> Bool
    
    /**
        Return the message to display on wrong validation.
        Use custom method if set or else use default message.
    */
    func getMessage() -> MD2String
    
}