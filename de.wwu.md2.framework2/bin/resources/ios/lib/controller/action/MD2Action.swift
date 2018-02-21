//
//  MD2Action.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for MD2 actions.
protocol MD2Action {
    
    /// Unique action identifier.
    var actionSignature: String { get }
    
    /// Execute the action commands.
    func execute()
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool
    
}