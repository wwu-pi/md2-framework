//
//  MD2LocationAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Action to lookup a location.

    *NOTICE* Not implemented yet.
*/
class MD2LocationAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The location.
    let location: MD2Location
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: location The location.
    */
    init(actionSignature: String, location: MD2Location) {
        self.actionSignature = actionSignature
        self.location = location
    }
    
    /// Execute the action commands.
    func execute() {
        // TODO include in later version
        fatalError("Location actions are not implemented!")
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}