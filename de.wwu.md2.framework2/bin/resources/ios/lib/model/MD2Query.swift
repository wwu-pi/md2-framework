//
//  MD2Query.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 22.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// A query specifying entity restrictions.
class MD2Query {
    
	/// A list of attribute-value pairs to be matched
    var predicates: Array<(String, String)> = []

    /**
	Add an attribute to value restriction.
	
	TODO for now only AND-Predicates are supported.
	
	:param: attribute The attribute to check.
	:param: value The value to check.
	*/
    func addPredicate(attribute: String, value: String) {
        predicates.append((attribute, value))
    }
}