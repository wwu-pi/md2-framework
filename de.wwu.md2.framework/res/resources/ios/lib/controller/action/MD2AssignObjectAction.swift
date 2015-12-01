//
//  MD2AssignObjectAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to assign a content provider to another content provider's attribute.
class MD2AssignObjectAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// Content provider to assign.
    let assignContentProvider: MD2ContentProvider
    
    /// Content provider to assign to other provider to.
    let toContentProvider: MD2ContentProvider
    
    /// The attribute of the target content provider.
    let attribute: String
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: assignContentProvider The content provider to assign.
        :param: toContentProvider The content procider to assign the other provider to.
        :param: attribute The attribute of the target content provider to set.
    */
    init(actionSignature: String, assignContentProvider: MD2ContentProvider, toContentProvider: MD2ContentProvider, attribute: String) {
        
        self.actionSignature = actionSignature
        self.assignContentProvider = assignContentProvider
        self.toContentProvider = toContentProvider
        self.attribute = attribute
    }
    
    /// Execute the action commands: Assign a content provider as provider to another content provider's attribute.
    func execute() {
        toContentProvider.registerAttributeContentProvider(attribute, contentProvider: assignContentProvider)
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}