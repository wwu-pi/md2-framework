//
//  MD2TemporalType.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for temporal data types.
protocol MD2TemporalType: MD2DataType {
    
    /**
        Greater-than comparison method.

        :param: value The value to compare with.

        :returns: Whether the object is greater than the parameter value.
    */
    func gt(value: MD2TemporalType) -> Bool
    
    /**
        Greater-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is greater or equal to the parameter value.
    */
    func gte(value: MD2TemporalType) -> Bool
    
    /**
        Lower-than comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower than the parameter value.
    */
    func lt(value: MD2TemporalType) -> Bool
    
    /**
        Lower-or-equal comparison method.
    
        :param: value The value to compare with.
    
        :returns: Whether the object is lower or equal to the parameter value.
    */
    func lte(value: MD2TemporalType) -> Bool
    
}