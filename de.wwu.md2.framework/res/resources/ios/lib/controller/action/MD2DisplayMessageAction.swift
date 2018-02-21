//
//  MD2DisplayMessageAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to display a popup message, e.g. for tooltips or other user information.
class MD2DisplayMessageAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The message to display.
    let message: String
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: message The message to display.
    */
    init(actionSignature: String, message: String) {
        self.actionSignature = actionSignature
        self.message = message
    }
    
    /// Execute the action commands: Show a model popup window with a message.
    func execute() {
        MD2UIUtil.showMessage(message, title: MD2ViewConfig.TOOLTIP_TITLE_MESSAGE)
    }
    
    /**
        Compare two action objects.

        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}