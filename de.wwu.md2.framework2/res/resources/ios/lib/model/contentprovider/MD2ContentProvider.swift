//
//  MD2ContentProvider.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for content providers.
protocol MD2ContentProvider: AnyObject {
    
    /// The managed entity.
    var content: MD2Entity? { get set }
    
    /// The data store managing the entity.
    var store: MD2DataStore { get set }
    
    /// List of observed attributes that should issue onContentChange events when changing.
    var observedAttributes: Dictionary<String, MD2Type> { get set }
    
    /// Nested content providers for attributes of the managed entity.
    var attributeContentProviders: Dictionary<String, MD2ContentProvider> { get set }
    
    /// Entity filter.
    var filter: MD2Filter? { get set }
    
    /// (Remote) path of the entity web service.
    var entityPath: String { get }
    
    /**
        Retrieve the managed entity.

        :returns: The managed entity if exists.
    */
    func getContent() -> MD2Entity?
    
    /// Set the managed entity by creating a new object.
    func setContent()
    
    /**
        Set the managed entity.

        :param: content The entity to manage.
    */
    func setContent(content: MD2Entity)
    
    /**
        Register an attribute to observe about changes.

        :param: attribute The attribute to observe.
    */
    func registerObservedOnChange(attribute: String)
    
    /**
        Unegister an attribute to observe about changes.
    
        **IMPORTANT** This is not observer-specific and will remove any observers.
    
        :param: attribute The attribute to stop observing.
    */
    func unregisterObservedOnChange(attribute: String)
    
    /**
        Retrieve an attribute value of the managed entity.
        
        :param: attribute The attribute name.
        
        :returns: The attribute value if exists.
    */
    func getValue(attribute: String) -> MD2Type?
    
    /**
        Set an attribute value of the managed entity.

        :param: attribute The attribute name.
        :param: value The attribute value to set.
    */
    func setValue(attribute: String, value: MD2Type)
    
    /**
        Add a content provider that manages an attribute of the managed entity.

        :param: attribute The affected attribute.
        :param: contentProvider The managing content provider object.
    */
    func registerAttributeContentProvider(attribute: String, contentProvider: MD2ContentProvider)
    
    /**
        Check all observed attributes and fire an update event. 
    */
    func checkAllAttributesForObserver()
    
    /**
        Reset the content provider by reloading the currently managed entity and discard all changes.
    */
    func reset()
    
    /**
        Load the entity to manage from the data store.
    */
    func load()
    
    /**
        Save the managed entity to the data store by creating or updating.
    */
    func save()
    
    /**
        Delete the managed entity (also from the data store).
    */
    func remove()
    
}