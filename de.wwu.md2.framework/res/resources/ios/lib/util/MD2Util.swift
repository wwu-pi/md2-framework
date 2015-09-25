//
//  MD2Util.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 10.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

/// Utility class for generic functions
class MD2Util {
    
    /**
        Get the class name as String.

        *Notice*  inspection is very limited so a standard library function is needed instead.
    
        :param: object The object to inspect.
    
        :returns: The class name.
    */
    static func getClassName(object: Any) -> String {
        return _stdlib_getDemangledTypeName(object).componentsSeparatedByString(".").last!
    }
    
    static func getBackendClassName(object: MD2Entity) -> String {
        return getClassName(object).componentsSeparatedByString("MD2Entity_").last!
    }
    
    /**
        Generic function to transform an asynchronous operation to a synchonous one.
    
        May be used for synchronous webservice calls instead of the current implementation.
        See http://stackoverflow.com/questions/30992363/turn-sharedloader-function-into-a-normal-function.
    
        :params: async The asynchronous function handler.
    
        :returns: The asynchronous handler result as regular function result.
    */
    static func syncFromAsync<R>(async: (handler: R -> Void) -> Void) -> R {
        let group = dispatch_group_create()
        var result : R!
        
        func handler(r : R) {
            result = r
            dispatch_group_leave(group)
        }
        
        dispatch_group_enter(group)
        async(handler: handler)
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        return result
    }
}
