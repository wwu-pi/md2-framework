//
//  MD2OnContentChangeHandler.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 06.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Event handler for content provider changes.
class MD2OnContentChangeHandler: MD2ContentProviderEventHandler {
    
    /// The singleton instance.
    static let instance: MD2OnContentChangeHandler = MD2OnContentChangeHandler()
    
    /// The list of registered contentProvider-attribute-action tuples.
    var actions: Dictionary<MD2ContentProviderAttributeIdentity, MD2Action> = [:]
    
    /// Singleton initializer.
    private init() {
        // Nothing to initialize
    }
    
    /**
        Register an action.
    
        :param: action The action to execute in case of an event.
        :param: contentProvider The content provider that the action should be bound to.
        :param: attribute The content provider attribute the action should be bound to.
    */
    func registerAction(action: MD2Action, contentProvider: MD2ContentProvider, attribute: String) {
        actions[MD2ContentProviderAttributeIdentity(contentProvider, attribute)] = action
    }
    
    /**
        Unregister an action.
    
        :param: action The action to remove.
        :param: contentProvider The content provider the action was registered to.
        :param: attribute The content provider attribute the action was registered to.
    */
    func unregisterAction(action: MD2Action, contentProvider: MD2ContentProvider, attribute: String) {
        for (cpaIdentity, value) in actions {
            if cpaIdentity == MD2ContentProviderAttributeIdentity(contentProvider, attribute) {
                actions[cpaIdentity] = nil
                break
            }
        }
    }
    
    /**
        Method that is called to fire an event.
    
        :param: contentProviderAttributeIdentity The content provider attribute sending the event.
    */
    func fire(contentProviderAttributeIdentity: MD2ContentProviderAttributeIdentity) {
        for (cpaIdentity, action) in actions {
            if cpaIdentity == contentProviderAttributeIdentity {
                println("[OnContentChangeHandler] Execute action")
                action.execute()
            }
        }
    }
    
}