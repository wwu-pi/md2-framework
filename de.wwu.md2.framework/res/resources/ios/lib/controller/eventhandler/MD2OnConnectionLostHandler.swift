//
//  MD2OnConnectionLostHandler.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Event handler to react to connection losses.
class MD2OnConnectionLostHandler: MD2GlobalEventHandler {
    
    /// The singleton instance.
    static let instance: MD2OnConnectionLostHandler = MD2OnConnectionLostHandler()
    
    /// The list of registered actions.
    var actions: Dictionary<String, MD2Action> = [:]
    
    /// Singleton initializer.
    private init() {
        // Nothing to initialize
    }
    
    /**
        Register an action to execute when the connection is lost.
    
        :param: action The action to execute in case of an event.
    */
    func registerAction(action: MD2Action) {
        actions[action.actionSignature] = action
    }
    
    /**
        Unregister an action.
    
        :param: action The action to remove.
    */
    func unregisterAction(action: MD2Action) {
        for (key, value) in actions {
            if key == action.actionSignature {
                actions[key] = nil
                break
            }
        }
    }
    
    /**
        Method that is called to fire an event.
    
        *Notice* Visible to Objective-C runtime to receive events.
    */
    @objc
    func fire() {
        //println("Event fired to OnClickHandler: " + String(sender.tag) + "=" + WidgetMapping.fromRawValue(sender.tag).description)
        
        for (_, action) in actions {
            action.execute()
        }
    }
    
}