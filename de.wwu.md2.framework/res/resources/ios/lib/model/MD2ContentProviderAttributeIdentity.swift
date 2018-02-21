//
//  MD2ContentProviderAttributeIdentity.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 06.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

import Foundation

/**
    Operator overloading to compare two contentProvider-attribute identity objects.

    *Notice* Needed to implement the Equatable protocol as supertype of the Hashable protocol.
*/
func ==(lhs: MD2ContentProviderAttributeIdentity, rhs: MD2ContentProviderAttributeIdentity) -> Bool {
    return lhs.contentProvider === rhs.contentProvider && lhs.attribute == rhs.attribute
}

/**
    An object representing the combined identity of a content provider and an attribute.

    *Notice* For using this object as dictionary key this

    - must be a class, not a struct

    - must be visible to Objective-C runtime (@objc)

    - must implement the Hashable protocol (which itself requires the Equatable protocol)
*/
@objc
class MD2ContentProviderAttributeIdentity: Hashable {
    
	/// The content provider object.
    let contentProvider: MD2ContentProvider
    
	/// The attribute string.
    let attribute: String
    
	/// The internal hash value.
    private let _hashValue: Int
    
	/// The externally facing hash value.
    var hashValue: Int {
        get {
            return _hashValue
        }
    }
    
	/**
        Initializing function which automatically sets a random hash value.
	
        :param: contentProvider The content provider object.
        :param: attribute The attribute string.
	*/
    init(_ contentProvider: MD2ContentProvider, _ attribute: String) {
        self.contentProvider = contentProvider
        self.attribute = attribute
        self._hashValue = Int(arc4random_uniform(999999999))
    }
}
