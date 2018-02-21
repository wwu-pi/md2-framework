//
//  MD2CombinedAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.09.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Combined action grouping other actions.
class MD2CombinedAction: MD2Action {
    
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The list of contained actions.
    let actionList: Array<MD2Action>
    
    /**
    Default initializer.
    
    :param: actionSignature The action identifier.
    :param: actionList The list of contained actions.
    */
    init(actionSignature: String, actionList: Array<MD2Action>) {
        self.actionSignature = actionSignature
        self.actionList = actionList
    }
    
    /// Execute the action commands: Execute all contained actions.
    func execute() {
        for action in actionList {
            action.execute()
        }
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}