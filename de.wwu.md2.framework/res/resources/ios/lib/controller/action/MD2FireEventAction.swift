//
//  MD2FireEventAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to fire a workflow event.
class MD2FireEventAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The workflow event to trigger.
    let event: MD2WorkflowEvent
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: event The workflow event to trigger.
    */
    init(actionSignature: String, event: MD2WorkflowEvent) {
        self.actionSignature = actionSignature
        self.event = event
    }
    
    /// Execute the action commands: Fire a workflow event.
    func execute() {
        MD2WorkflowEventHandler.instance.fire(event)
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}