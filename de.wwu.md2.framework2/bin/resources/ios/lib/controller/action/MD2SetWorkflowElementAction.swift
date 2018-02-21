//
//  MD2SetWorkflowElementAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to switch to a specified workflow element.
class MD2SetWorkflowElementAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The workflow element to set.
    let workflowElement: MD2WorkflowElement
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: workflowElement The workflow element to set.
    */
    init(actionSignature: String, workflowElement: MD2WorkflowElement) {
        self.actionSignature = actionSignature
        self.workflowElement = workflowElement
    }
    
    /// Execute the action commands: Switch to another workflow element.
    func execute() {
        MD2WorkflowManager.instance.goToWorkflow(workflowElement)
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}