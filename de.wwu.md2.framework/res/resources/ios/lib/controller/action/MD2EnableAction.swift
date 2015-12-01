//
//  MD2EnableAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to enable a view element.
class MD2EnableAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The view element to enable.
    let viewElement: MD2Widget
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: viewElement The view element to enable.
    */
    init(actionSignature: String, viewElement: MD2Widget) {
        self.actionSignature = actionSignature
        self.viewElement = viewElement
    }
    
    /// Execute the action commands: Enable a view element.
    func execute() {
        self.viewElement.enable()
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}