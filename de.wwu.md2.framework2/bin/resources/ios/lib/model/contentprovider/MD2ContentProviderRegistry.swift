//
//  MD2ContentProviderRegistry.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Registry for content providers.
class MD2ContentProviderRegistry {
    
    /// The singleton instance.
    static let instance: MD2ContentProviderRegistry = MD2ContentProviderRegistry()
    
    /// Collection of registered widgets.
    var contentProviders: Dictionary<String, MD2ContentProvider> = [:]
    
    /**
        Register a content provider.
    
        :param: contentProviderName The content provider identifier to register.
        :param: provider The content provider object.
    */
    func addContentProvider(contentProviderName: String, provider: MD2ContentProvider) {
        contentProviders[contentProviderName] = provider
    }
    
    /**
        Retrieve a content provider object.
    
        :param: contentProviderName The identifier of the content provider.
    
        :returns: The content provider element if found.
    */
    func getContentProvider(contentProviderName: String) -> MD2ContentProvider? {
        return contentProviders[contentProviderName]
    }
    
}