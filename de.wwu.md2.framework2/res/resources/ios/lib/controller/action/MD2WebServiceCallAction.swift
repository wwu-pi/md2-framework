//
//  MD2WebServiceCallAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/**
    Action to call an external web service.

    *NOTICE* Not implemented/specified yet.
*/
class MD2WebServiceCallAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The web service call (not fully specified yet)
    let webServiceCall: String
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: webServiceCall The web service call.
    */
    init(actionSignature: String, webServiceCall: String) {
        self.actionSignature = actionSignature
        self.webServiceCall = webServiceCall
    }
    
    /// Execute the action commands: Call an external web service.
    func execute() {
        // TODO
        fatalError("Arbitrary web service calls are not implemented")
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}