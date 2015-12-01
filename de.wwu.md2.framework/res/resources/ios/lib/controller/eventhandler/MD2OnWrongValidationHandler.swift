//
//  MD2OnWrongValidationHandler.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 05.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Event handler for failed validations.
class MD2OnWrongValidationHandler: MD2WidgetEventHandler {
    
    /// Convenience typealias for the tuple of action and widget
    typealias actionWidgetTuple = (MD2Action, MD2WidgetWrapper)
    
    /// The singleton instance.
    static let instance: MD2OnWrongValidationHandler = MD2OnWrongValidationHandler()
    
    /// The list of registered action-widget tuples.
    var actions: Dictionary<String,actionWidgetTuple> = [:]
    
    /// Singleton initializer.
    private init() {
        // Nothing to initialize
    }
    
    /**
        Register an action.
    
        :param: action The action to execute in case of an event.
        :param: widget The widget that the action should be bound to.
    */
    func registerAction(action: MD2Action, widget: MD2WidgetWrapper) {
        actions[action.actionSignature] = (action, widget)
    }
    
    /**
        Unregister an action.
    
        :param: action The action to remove.
        :param: widget The widget the action was registered to.
    */
    func unregisterAction(action: MD2Action, widget: MD2WidgetWrapper) {
        for (key, value) in actions {
            if key == action.actionSignature {
                actions[key] = nil
                break
            }
        }
    }
    
    /**
        Method that is called to fire an event.
    
        *Notice* Visible to Objective-C runtime to receive events from UI elements.
    
        :param: sender The widget sending the event.
    */
    @objc
    func fire(sender: MD2WidgetWrapper) {
        //println("Event fired to OnWrongValidationHandler: " + sender.widgetId.description)
        
        for (_, (action, widget)) in actions {
            if widget.widgetId == sender.widgetId {
                action.execute()
            }
        }
    }
    
}