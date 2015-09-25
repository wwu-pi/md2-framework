//
//  MD2Event.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 14.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Enumeration to define constants for all MD2 events.
enum MD2Event {
    // WidgetEvents
    case OnClick
    case OnWidgetChange
    case OnLeftSwipe
    case OnRightSwipe
    case OnWrongValidation
    case OnTooltip
    
    // ContentProviderEvents
    case OnContentChange
    
    // GlobalEvents
    case OnConnectionLost
    case OnConnectionRegained
    case OnLocationUpdate
    
    /**
        Retrieve the event handler object managing the respective event type.
        Used to decouple event sending and receipt as much as possible.
        
        :returns: The responsible event handler.
    */
    func getEventHandler() -> MD2EventHandler {
        switch self {
        case OnClick: return MD2OnClickHandler.instance
        case OnWidgetChange: return MD2OnWidgetChangeHandler.instance
        case OnLeftSwipe: return MD2OnLeftSwipeHandler.instance
        case OnRightSwipe: return MD2OnRightSwipeHandler.instance
        case OnWrongValidation: return MD2OnWrongValidationHandler.instance
        case OnContentChange: return MD2OnContentChangeHandler.instance
        case OnConnectionLost: return MD2OnConnectionLostHandler.instance
        case OnConnectionRegained: return MD2OnConnectionRegainedHandler.instance
        case OnLocationUpdate: return MD2OnLocationUpdateHandler.instance
        case OnTooltip: return MD2TooltipHandler.instance
        }
    }
    
    /**
        Retrieve the method selector (name + attribute) that triggers the event in the respective event handler.
        Used to decouple event sending and receipt as much as possible.
    
        :returns: The responsible target method as string (to use as Objective-C method selector).
    */
    func getTargetMethod() -> String {
        switch self {
        case OnClick: return "fire:"
        case OnWidgetChange: return "fire:"
        case OnLeftSwipe: return "fire:"
        case OnRightSwipe: return "fire:"
        case OnWrongValidation: return "fire:"
        case OnContentChange: return "fire:"
        case OnConnectionLost: return "fire" // no parameter
        case OnConnectionRegained: return "fire" // no parameter
        case OnLocationUpdate: return "fire" // no parameter
        case OnTooltip: return "fire:"
        }
    }
    
    /**
        Determine if the event type is a widget event.
    
        :returns: Is the event type a widget event.
    */
    func isWidgetEvent() -> Bool {
        return self == .OnClick || self == .OnWidgetChange || self == .OnLeftSwipe || self == .OnRightSwipe || self == OnWrongValidation
    }
    
    /**
        Determine if the event type is a content provider event.
    
        :returns: Is the event type a content provider event.
    */
    func isContentProviderEvent() -> Bool {
        return self == .OnContentChange
    }
    
    /**
        Determine if the event type is a global event.
    
        :returns: Is the event type a global event.
    */
    func isGlobalEvent() -> Bool {
        return self == .OnConnectionLost || self == .OnConnectionRegained || self == .OnLocationUpdate
    }
    
}