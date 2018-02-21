//
//  MD2DataStoreFactory.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Data store factory to decide at runtime which data store to use.
class MD2DataStoreFactory<T: MD2Entity> {
    
    /**
        Create da data store for the entity specified as generic class argument and the entityPath.
        
        Current implementations:
        
        - MD2LocalStore: Used if no entityPath is specified.
    
        - MD2RemoteStore: Assumes a REST service if an entityPath is given.
    
        :param: entityPath The entityPath.
    
        :returns: The data store.
    */
    func createStore(entityPath: String) -> MD2DataStore {
        if entityPath == "" {
            // Create and initialize a local data store
            return MD2LocalStore<T>()
        } else {
            // Create and initialize a local data store
            return MD2RemoteStore<T>(entityPath: entityPath)
        }
    }
}