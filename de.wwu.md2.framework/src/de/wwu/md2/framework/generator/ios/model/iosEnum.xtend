package de.wwu.md2.framework.generator.ios.model

import de.wwu.md2.framework.mD2.Enum

class iosEnum {
	
	def static generateClass(Enum enumInstance) '''
//
//  «enumInstance.name».swift
//  Generated code by class 'iosEnum'
//

class «enumInstance.name»: MD2EnumType {
    
    typealias T = «enumInstance.name».EnumType
    
    var platformValue: «enumInstance.name».EnumType?
    
    func clone() -> MD2Type {
        var newInstance = «enumInstance.name»()
        newInstance.platformValue = self.platformValue
        return newInstance
    }
    
    func toString() -> String {
        if let _ = platformValue {
            return platformValue!.rawValue
        } else {
            return ""
        }
    }
    
    func equals(value : MD2Type) -> Bool {
        return platformValue != nil
                && value is «enumInstance.name»
                && platformValue?.rawValue == (value as! «enumInstance.name»).platformValue?.rawValue
    }
    
    enum EnumType: String {
    	«var i = 1»
    	«FOR value : enumInstance.enumBody.elements»
    	case Elem«i++» = "«value»"
        «ENDFOR»
        
        «var j = 1»
        static let allValues = [«FOR value : enumInstance.enumBody.elements SEPARATOR ', '»Elem«j++»«ENDFOR»]
    }
    
    func getAllValues() -> Array<String> {
        var array: Array<String> = []
        for elem in «enumInstance.name».EnumType.allValues {
            array.append(elem.rawValue)
        }
        return array
    }
}
	'''
	
}