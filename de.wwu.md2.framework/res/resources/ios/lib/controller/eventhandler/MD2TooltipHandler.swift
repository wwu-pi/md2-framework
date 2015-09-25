//
//  TooltipHandler.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 06.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import UIKit

/// Event handler for tooltip handling.
class MD2TooltipHandler: MD2WidgetEventHandler {
    
    /// The singleton instance.
    static let instance: MD2TooltipHandler = MD2TooltipHandler()
    
    /// Singleton initializer.
    private init() {
        // Nothing to initialize
    }
    
    /**
        Register an action.

        :param: action The action to execute in case of an event.
        :param: widget The widget that the action is bound to.
    */
    func registerAction(action: MD2Action, widget: MD2WidgetWrapper) {
        // Not neccessary, tooltips are created dynamically when fired.
    }
    
    /**
        Unregister an action.
    
        :param: action The action to remove.
        :param: widget The widget the action was registered to.
    */
    func unregisterAction(action: MD2Action, widget: MD2WidgetWrapper) {
        // Not neccessary
    }
    
    /**
        Method that is called to fire an event.
    
        *Notice* Visible to Objective-C runtime to receive events from UI elements.
    
        :param: sender The widget sending the event.
    */
    @objc
    func fire(sender: UIControl) {
        let wrapper = MD2WidgetRegistry.instance.getWidget(MD2WidgetMapping.fromRawValue(sender.tag))
            
        if wrapper == nil || wrapper?.widget == nil || !(wrapper!.widget is MD2AssistedWidget) {
            return
        }
        
        if (wrapper!.widget as! MD2AssistedWidget).tooltip != nil {
            MD2UIUtil.showMessage((wrapper!.widget as! MD2AssistedWidget).tooltip!.toString(),
                title: MD2ViewConfig.TOOLTIP_TITLE_INFO)
        }
    }
    
}