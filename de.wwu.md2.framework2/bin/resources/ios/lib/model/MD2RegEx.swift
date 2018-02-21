//
//  MD2RegEx.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

infix operator =~ {}

/// An operator to simplify matching strings against a specified pattern
func =~ (input: MD2String, pattern: MD2String) -> Bool {
    return MD2RegEx(pattern: pattern).test(input)
}

/**
    A regular expression object.

    Implementation adapted from http://benscheirman.com/2014/06/regex-in-swift/
*/
class MD2RegEx {
    /// The internal Objective-C regular expression object.
    let expression: NSRegularExpression?
    
    /// The RegEx pattern as string.
    let pattern: MD2String
    
    /**
        Initialize the object by setting a pattern string and transforming it to the native object.
    
        :param: pattern The RegEx pattern as string.
    */
    init(pattern: MD2String) {
        self.pattern = pattern
        
        if let _ = pattern.platformValue {
            var error: NSError?
            expression = NSRegularExpression(pattern: pattern.platformValue!, options: .CaseInsensitive, error: &error)
        } else {
            expression = nil
        }
    }
    
    /**
        Test the given input string to match against the expression.
    
        :param: input The input string to test
    
        :returns: Whether at least one match was found.
    */
    func test(input: MD2String) -> Bool {
        if expression == nil || !input.isSet() {
            return false
        }
        
        let matches = self.expression!.matchesInString(input.platformValue!, options: nil, range:NSMakeRange(0, count(input.platformValue!)))
        return matches.count > 0
    }
}
