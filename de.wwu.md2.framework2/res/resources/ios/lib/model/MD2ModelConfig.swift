//
//  MD2ModelConfig.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Configuration values for the app's model
class MD2ModelConfig {
    
    /// Error threshold to allow comparisons on floating point variables
    static let FLOATING_ERROR: Float = 0.0000001
    
    /// String format of time data type
    static let STRING_FORMAT_TIME = "HH:mm:ss"
    /// String format of datetime data type
    static let STRING_FORMAT_DATETIME = "yyyy-MM-dd HH:mm:ss"
    /// String format of date data type
    static let STRING_FORMAT_DATE = "yyyy-MM-dd"
    
}
