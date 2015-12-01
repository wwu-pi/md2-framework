//
//  MD2GlobalEventHandler.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 23.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for global event handlers.
protocol MD2GlobalEventHandler: MD2EventHandler {
    
    /**
        Register an action to a global event handler.

        :param: action The action to execute in case of an event.
    */
    func registerAction(action: MD2Action)
    
    /**
        Unregister an action from a global event handler.
    
        :param: action The action to remove.
    */
    func unregisterAction(action: MD2Action)
    
}
