//
//  MD2NewObjectAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to create an empty object within a content provider.
class MD2NewObjectAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The content provider to change.
    let contentProvider: MD2ContentProvider
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: contentProvider The content provider to change.
    */
    init(actionSignature: String, contentProvider: MD2ContentProvider) {
        self.actionSignature = actionSignature
        self.contentProvider = contentProvider
    }
    
    /// Execute the action commands: Create a new object in the content provider.
    func execute() {
        contentProvider.setContent()
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}