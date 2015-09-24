package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.generator.ios.Settings
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil

class IOSEnum {
	
	static var className = ""
	
	def static generateClass(Enum enumInstance) {
		className = Settings.PREFIX_ENUM + enumInstance.name.toFirstUpper
		
		generateClassContent(enumInstance)
	} 
	
	def static generateClassContent(Enum enumInstance) '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

/// Interface for the «className» data type.
class «className»: MD2Enum {
    
    /**
        Unfortunately, a platformValue cannot be specified as attribute of the interface MD2DataType according to the reference architecture because enumeration types are distinct first-level types.
    
        Reason: Specifying a generic type, e.g. via typealias does not work in Swift yet because subsequent methods will not accept MD2DataType as input anymore (error: Protocol of type MD2DataType can only be used as generic constraint...).
    
        Using type Any? instead is the only viable option although of limited help as type casting needs to be done twice on every element like this: ((value as! MD2Integer).platformValue as! Int) which is cumbersome. In addition, it does not even enforce a specific type either but may instead cause runtime errors if the platformValue was set directly using the "wrong" type. A property oberser could check this but again relies on the actual implementation and cannot be specified here.
    */
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    /// The enumeration type value.
    var platformValue: «className».EnumType?
    
    /// Empty initializer.
    init() {
        // Nothing to initialize
    }
    
    /**
        Deserialize the string representation to an enumeration value.
        
        :param: value The string representation to use.
    */
    func setValueFromString(value: MD2String) {
        if value.isSet() && !value.equals(MD2String("")) {
            platformValue = EnumType.fromRawValue(value.toString())
        }
    }
    
    /**
        Clone an object.
        
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        var newInstance = «className»()
        newInstance.platformValue = self.platformValue
        return newInstance
    }
    
    /**
        Get a string representation of the object.
        
        :returns: The string representation
    */
    func toString() -> String {
        if let _ = platformValue {
            return "«className»: [" + platformValue!.rawValue + "]"
        } else {
            return "«className»: []"
        }
    }
    
    /**
        Serialization of an enumeration value to integer.
        
        :returns: The integer value.
    */
    func toInt() -> Int {
        if let _ = platformValue {
            return platformValue!.toInt
        } else {
            return 0
        }
    }
    
    /**
        Deserialization from an integer value.
        
        :param: value The value to convert to an enumeration.
    */
    func setValueFromInt(value: Int) {
        platformValue = EnumType.fromInt(value)
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
        
        :param: value The object to compare with.
        
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        return platformValue != nil
                && value is «className»
                && platformValue?.rawValue == (value as! «className»).platformValue?.rawValue
    }
    
    enum EnumType: String {
    	«FOR i : 0..<enumInstance.enumBody.elements.length»
    	case Elem«(i+1)» = "«enumInstance.enumBody.elements.get(i)»"
        «ENDFOR»
        
        /// Helper property due to missing enum introspection in Swift. Array to list all possible enum values.
        static let allValues = [«FOR i : 0..<enumInstance.enumBody.elements.length SEPARATOR ', '»Elem«(i+1)»«ENDFOR»]
        
        /**
            Create an enum value from its string representation.
            
            :param: value The string representation.
            
            :returns: The enumeration value.
        */
        static func fromRawValue(value: String) -> EnumType? {
            switch value {
            	«FOR i : 0..<enumInstance.enumBody.elements.length»
            	case "«enumInstance.enumBody.elements.get(i)»": return Elem«(i+1)»
        		«ENDFOR»
            	default: return nil
            }
        }
        
        /// Computed property to serialize the enumeration value to an integer value.
        var toInt: Int {
            switch self {
	            «FOR i : 0..<enumInstance.enumBody.elements.length»
	            case Elem«(i+1)»: return «(i+1)»
	        	«ENDFOR»
            }
        }
        
        /**
            Create an enum value from its integer representation.
            
            :param: value The integer value.
            
            :returns: The enumeration value.
        */
        static func fromInt(value: Int) -> EnumType? {
            switch value {
            	«FOR i : 0..<enumInstance.enumBody.elements.length»
            	case «(i+1)»: return Elem«(i+1)»
	        	«ENDFOR»
            	default: return nil
            }
        }
    }
    
    /**
        Helper function due to missing introspection capabilities: Retrieve a list of all enumeration values.
        
        :returns: List of string values
    */
    func getAllValues() -> Array<String> {
        var array: Array<String> = []
        for elem in «className».EnumType.allValues {
            array.append(elem.rawValue)
        }
        return array
    }
    
    /**
        Get a string representation of the enumeration value.
        
        :returns: The string representation.
    */
    func getValue() -> String {
        if let _ = platformValue {
            return platformValue!.rawValue
        } else {
            return ""
        }
    }
}
	'''
}