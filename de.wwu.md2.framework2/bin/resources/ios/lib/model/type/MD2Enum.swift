//
//  MD2Enum.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 21.07.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Interface for MD2 enumeration data type.
protocol MD2Enum: MD2Type {
    
    /**
        Unfortunately, a platformValue cannot be specified as attribute of the interface MD2DataType according to the reference architecture because enumeration types are distinct first-level types.
    
        Reason: Specifying a generic type, e.g. via typealias does not work in Swift yet because subsequent methods will not accept MD2DataType as input anymore (error: Protocol of type MD2DataType can only be used as generic constraint...).
    
        Using type Any? instead is the only viable option although of limited help as type casting needs to be done twice on every element like this: ((value as! MD2Integer).platformValue as! Int) which is cumbersome. In addition, it does not even enforce a specific type either but may instead cause runtime errors if the platformValue was set directly using the "wrong" type. A property oberser could check this but again relies on the actual implementation and cannot be specified here.
    */
    var value: Any? { get }
    
    /**
        Deserialize the string representation to an enumeration value.

        :param: value The string representation to use.
    */
    func setValueFromString(value: MD2String)
    
    /**
        Helper function due to missing introspection capabilities: Retrieve a list of all enumeration values.

        :returns: List of string values
    */
    func getAllValues() -> Array<String>
    
    /**
        Serialization of an enumeration value to integer.
    
        :returns: The integer value.
    */
    func toInt() -> Int
    
    /**
        Deserialization from an integer value.

        :param: value The value to convert to an enumeration.
    */
    func setValueFromInt(value: Int)
}