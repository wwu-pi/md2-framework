//
//  MD2ContentProviderOperationAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to load save or delete a content provider managed entity.
class MD2ContentProviderOperationAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The operation type to perform.
    let allowedOperation: AllowedOperation
    
    /// The content provider on which to perform the action.
    let contentProvider: MD2ContentProvider
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: allowedOperation The content provider operation type.
        :param: contentProvider The content provider on which to perform the action.
    */
    init(actionSignature: String, allowedOperation: AllowedOperation, contentProvider: MD2ContentProvider) {
        self.actionSignature = actionSignature
        self.allowedOperation = allowedOperation
        self.contentProvider = contentProvider
    }
    
    /// Execute the action commands: Perform a content provider operation.
    func execute() {
        switch allowedOperation {
        case AllowedOperation.Load: contentProvider.load()
        case AllowedOperation.Save: contentProvider.save()
        case AllowedOperation.Remove: contentProvider.remove()
        default: return
        }
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
    /// Enumeration of all allowed content provider operations.
    enum AllowedOperation {
        case Save, Load, Remove
    }
    
}