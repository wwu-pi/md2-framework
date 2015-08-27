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

class «className»: MD2EnumType {
    
    var value: Any? {
        get {
            return platformValue
        }
    }
    
    var platformValue: «className».EnumType?
    
    init() {
        // Nothing to initialize
    }
    
    func setValueFromString(value: MD2String) {
        if value.isSet() && !value.equals(MD2String("")) {
            platformValue = EnumType.fromRawValue(value.toString())
        }
    }
    
    func clone() -> MD2Type {
        var newInstance = «className»()
        newInstance.platformValue = self.platformValue
        return newInstance
    }
    
    func toString() -> String {
        if let _ = platformValue {
            return "«className»: [" + platformValue!.rawValue + "]"
        } else {
            return "«className»: []"
        }
    }
    
    func toInt() -> Int {
        if let _ = platformValue {
            return platformValue!.toInt
        } else {
            return 0
        }
    }
    
    func setValueFromInt(value: Int) {
        platformValue = EnumType.fromInt(value)
    }
    
    func equals(value : MD2Type) -> Bool {
        return platformValue != nil
                && value is «className»
                && platformValue?.rawValue == (value as! «className»).platformValue?.rawValue
    }
    
    enum EnumType: String {
    	«FOR i : 1.. enumInstance.enumBody.elements.length»
    	case Elem«i» = "«enumInstance.enumBody.elements.get(i - 1)»"
        «ENDFOR»
        
        static let allValues = [«FOR i : 1.. enumInstance.enumBody.elements.length SEPARATOR ', '»Elem«i»«ENDFOR»]
        
        static func fromRawValue(value: String) -> EnumType? {
            switch value {
            	«FOR i : 1.. enumInstance.enumBody.elements.length»
            	case "«enumInstance.enumBody.elements.get(i - 1)»": return Elem«i»
        		«ENDFOR»
            	default: return nil
            }
        }
        
        var toInt: Int {
            switch self {
	            «FOR i : 1.. enumInstance.enumBody.elements.length»
	            case Elem«i»: return «i»
	        	«ENDFOR»
            }
        }
        
        static func fromInt(value: Int) -> EnumType? {
            switch value {
            	«FOR i : 1.. enumInstance.enumBody.elements.length»
            	case «i»: return Elem«i»
	        	«ENDFOR»
            	default: return nil
            }
        }
    }
    
    func getAllValues() -> Array<String> {
        var array: Array<String> = []
        for elem in «className».EnumType.allValues {
            array.append(elem.rawValue)
        }
        return array
    }
    
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