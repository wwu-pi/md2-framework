package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.impl.EntityImpl
import de.wwu.md2.framework.mD2.impl.BooleanTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTimeTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTypeImpl
import de.wwu.md2.framework.mD2.impl.FloatTypeImpl
import de.wwu.md2.framework.mD2.impl.IntegerTypeImpl
import de.wwu.md2.framework.mD2.impl.StringTypeImpl
import de.wwu.md2.framework.mD2.impl.TimeTypeImpl
import java.lang.invoke.MethodHandles
import de.wwu.md2.framework.mD2.impl.ReferencedTypeImpl
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil

class IOSEntity {
	
	/**
	 * The Swift class name.
	 */
	static var className = ""
	
	/**
	 * Generates the Swift type. Prepares the class generation and calls the template.
	 * 
	 * @param entityInstance The entity element.
	 * @return The file content.
	 */
	def static generateClass(Entity entityInstance) {
		className = Settings.PREFIX_ENTITY + entityInstance.name.toFirstUpper
		
		generateClassContent(entityInstance)
	} 
	
	/**
	 * Template to output the MD2 entity type.
	 * 
	 * @param entityInstance The entity element to generate.
	 * @return The file content.
	 */
	def static generateClassContent(Entity entityInstance) '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

import Foundation

/**
    Model-specific entity class.
    
    *Objc* Make class visible for Objective-C to work with Core Data persistence framework
*/
@objc(«className»)
class «className»: NSObject, MD2Entity {
	
	/// Original class name in the MD2 model
	var md2ClassName: String = "«entityInstance.name.toFirstUpper»"
    
    /// The internal value of the entity object, set when the data store creates an Id after first saving the object.
    var internalId: MD2Integer = MD2Integer()
    
    /// Key-value list of contained attributes.
    var containedTypes: Dictionary<String, MD2Type> = [:]
    
    /// Empty initializer is required.
    required override init() {
        // Initialize fields
        «FOR attribute : entityInstance.attributes»
        «IF attribute.extendedName != null »
        // «attribute.extendedName»
        «ENDIF»
        containedTypes["«attribute.name»"] = «generateEntityType(attribute)»
        «ENDFOR»
    }
    
    /**
        Initializer to create an object from the same data type (=copy).

        :param: md2Entity The entity to copy.
    */
    convenience init(md2Entity: «className») {
        self.init()
        
        for (typeName, typeValue) in md2Entity.containedTypes {
            containedTypes[typeName] = typeValue.clone()
        }
    }
    
    /**
        Clone an object.
    
        :returns: A copy of the object.
    */
    func clone() -> MD2Type {
        return «className»(md2Entity: self)
    }
    
    /**
        Get a string representation of the object.
    
        :returns: The string representation
    */
    func toString() -> String {
    return "(«className»: [«FOR attribute : entityInstance.attributes SEPARATOR '\n+ ", '»«attribute.name»: " + containedTypes["«attribute.name»"]!.toString()«ENDFOR» 
	        + "])"
    }
    
    /**
        Compare two objects based on their content (not just comparing references).
    
        :param: value The object to compare with.
    
        :returns: Whether the values are equal or not.
    */
    func equals(value : MD2Type) -> Bool {
        if !(value is «className») {
            return false
        }
        
        var isEqual = true
        
        for (typeName, typeValue) in (value as! «className»).containedTypes {
            if !(containedTypes[typeName] != nil && containedTypes[typeName]!.equals(typeValue)) {
                isEqual = false
                break
            }
        }
        
        return isEqual
    }
    
    /**
        Retrieve an attribute value.
    
        :param: attribute The attribute name.
    
        :returns: The attribute value if found.
    */
    func get(attribute: String) -> MD2Type? {
        return containedTypes[attribute]
    }
    
    /**
        Set an attribute value.
    
        :param: attribute The attribute name.
        :param: value The value to set.
    */
    func set(attribute: String, value: MD2Type) {
    	// Check if attribute exists
    	if containedTypes[attribute] == nil {
    		fatalError("Tried to set non-existing attribute in entity type «className»")
    	}
        containedTypes[attribute] = value
    }
}
	'''	

	def static generateEntityType(Attribute attribute) {
		switch attribute.type.class {
			case IntegerTypeImpl: return Settings.PREFIX_GLOBAL + "Integer()"
			case FloatTypeImpl: return Settings.PREFIX_GLOBAL + "Float()"
			case StringTypeImpl: return Settings.PREFIX_GLOBAL + "String()"
			case BooleanTypeImpl: return Settings.PREFIX_GLOBAL + "Boolean()"
			case DateTypeImpl: return Settings.PREFIX_GLOBAL + "Date()"
			case TimeTypeImpl: return Settings.PREFIX_GLOBAL + "Time()"
			case DateTimeTypeImpl: return Settings.PREFIX_GLOBAL + "DateTime()"
			case ReferencedTypeImpl: return "MD2String()"
				/* TODO Problem with recursive usage causing infinite loops on deep initialization
				{
				if(attribute.type instanceof ReferencedType && ((attribute.type as ReferencedType).element instanceof Entity)) {
					return Settings.PREFIX_ENTITY + ((attribute.type as ReferencedType).element as Entity).name + "()"
				} else {
					return Settings.PREFIX_ENUM + ((attribute.type as ReferencedType).element as Enum).name + "()"
				}
			}*/
			default: {
				IOSGeneratorUtil.printWarning("Encountered unsupported data type " + attribute.type + "! Will use 'String' to continue generation.")
				return Settings.PREFIX_GLOBAL + "String()" 
				}
		}
	}
}