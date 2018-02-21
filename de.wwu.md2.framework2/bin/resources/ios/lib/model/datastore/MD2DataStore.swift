//
//  MD2DataStore.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for data stores.
protocol MD2DataStore {
    
    /**
        Query the data store.

        :param: query The query to specify which entity to retrieve.

        :returns: The entity (if exists).
    */
    func query(query: MD2Query) -> MD2Entity?
    
    /**
        Create or update the entity in the data store.

        :param: entity The entity to persist.
    */
    func put(entity: MD2Entity)
    
    /**
        Remove an entity from the data store by Id.

        :param: internalId The Id of the entity to remove.
    */
    func remove(internalId: MD2Integer)
    
}