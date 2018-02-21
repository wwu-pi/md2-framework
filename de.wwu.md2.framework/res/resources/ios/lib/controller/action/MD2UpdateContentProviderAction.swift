//
//  MD2UpdateContentProviderAction.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 12.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Action to update a content provider on a widget change.
class MD2UpdateContentProviderAction: MD2Action {
    
    /// Unique action identifier.
    let actionSignature: String
    
    /// The view element that was updated.
    let viewElement: MD2WidgetWrapper
    
    //// The content provider to notify.
    let contentProvider: MD2ContentProvider
    
    /// The attribute of the content provider to update.
    let attribute: String
    
    /**
        Default initializer.
    
        :param: actionSignature The action identifier.
        :param: viewElement The view element that was updated.
        :param: contentProvider The content provider to notify.
        :param: attribute The affected attribute of the content provider.
    */
    init(actionSignature: String, viewElement: MD2WidgetWrapper, contentProvider: MD2ContentProvider, attribute: String) {
        self.actionSignature = actionSignature
        self.viewElement = viewElement
        self.contentProvider = contentProvider
        self.attribute = attribute
    }
    
    /// Execute the action commands: Notify content provider about widget change.
    func execute() {
        if let value = viewElement.getValue() {
            println("[UpdateContentProviderAction] Update " + actionSignature)
            self.contentProvider.setValue(attribute, value: value)
        }
    }
    
    /**
        Compare two action objects.
    
        :param: anotherAction The action to compare with.
    */
    func equals(anotherAction: MD2Action) -> Bool {
        return actionSignature == anotherAction.actionSignature
    }
    
}