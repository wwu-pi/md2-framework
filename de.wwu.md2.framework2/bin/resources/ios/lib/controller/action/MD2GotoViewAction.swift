//
//  MD2GotoViewAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to switch to another view.
class MD2GotoViewAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The target view to show.
    let targetView: MD2WidgetMapping
    
    /**
        Default initializer.

        :param: actionSignature The action identifier.
        :param: targetView The view to show.
    */
    init(actionSignature: String, targetView: MD2WidgetMapping) {
        self.actionSignature = actionSignature
        self.targetView = targetView
    }
    
    /// Execute the action commands: Switch to another view.
    func execute() {
        MD2ViewManager.instance.goTo(targetView.description)
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }

}