package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.GeneratorUtil
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.impl.BooleanTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTimeTypeImpl
import de.wwu.md2.framework.mD2.impl.DateTypeImpl
import de.wwu.md2.framework.mD2.impl.FloatTypeImpl
import de.wwu.md2.framework.mD2.impl.IntegerTypeImpl
import de.wwu.md2.framework.mD2.impl.StringTypeImpl
import de.wwu.md2.framework.mD2.impl.TimeTypeImpl
import java.lang.invoke.MethodHandles

class iosEntity {
	
	static var className = ""
	
	def static generateClass(Entity entityInstance) {
		className = Settings.PREFIX_ENTITY + entityInstance.name
		
		generateClassContent(entityInstance)
	} 
	
	def static generateClassContent(Entity entityInstance) '''
«GeneratorUtil.generateClassHeaderComment(Settings.PREFIX_ENUM + entityInstance.name, MethodHandles.lookup.lookupClass)»

import Foundation

// Make class visible for Objective-C to work with Core Data persistence framework
@objc(«className»)
class «className»: NSObject, MD2EntityType {

	var internalId: MD2Integer = MD2Integer()
    
    var containedTypes: Dictionary<String, MD2Type> = [:]
    
    required override init() {
        // Initialize fields
        «FOR attribute : entityInstance.attributes»
        «IF attribute.extendedName != null »
        // «attribute.extendedName»
        «ENDIF»
        containedTypes["«attribute.name»"] = «generateEntityType(attribute)»
        «ENDFOR»
    }
    
    convenience init(md2Entity: «className») {
        self.init()
        
        for (typeName, typeValue) in md2Entity.containedTypes {
            containedTypes[typeName] = typeValue.clone()
        }
    }
    
    func clone() -> MD2Type {
        return Address(md2Entity: self)
    }
    
    func toString() -> String {
        return "(«className»: [
	        «FOR attribute : entityInstance.attributes SEPARATOR '\n+ ", '»«attribute.name»: " + containedTypes["«attribute.name»"]!.toString()«ENDFOR» 
	        + "])"
    }
    
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
    
    func get(attribute: String) -> MD2Type? {
        return containedTypes[attribute]
    }
    
    func set(attribute: String, value: MD2Type) {
    	// Check if attribute exists
    	if containedTypes[attribute] == nil {
    		fatalError("Tried to set non-existing attribute in entity type «className»"")
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
			default: {
				GeneratorUtil.printWarning("Encountered unsupported data type " + attribute.type + "! Will use 'String' to continue generation.")
				return Settings.PREFIX_GLOBAL + "String()" 
				}
		}
	}
}