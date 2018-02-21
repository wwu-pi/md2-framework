package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.mD2.Enum
import java.util.Map

import static extension de.wwu.md2.framework.util.StringExtensions.*

class EnumClass {
	
	def static String generateEnum(Enum ^enum) '''
		«val imports = newLinkedHashMap("declare" -> "dojo/_base/declare", "_Enum" -> "md2_runtime/datatypes/_Enum")»
		«val body = generateEnumBody(^enum, imports)»
		define([
			«FOR key : imports.keySet SEPARATOR ","»
				"«imports.get(key)»"
			«ENDFOR»
		],
		function(«FOR key : imports.keySet SEPARATOR ", "»«key»«ENDFOR») {
			
			«body»
		});
	'''
	
	def private static generateEnumBody(Enum ^enum, Map<String, String> imports) '''
		var «enum.name.toFirstUpper» = declare([_Enum], {
			
			_datatype: "«enum.name.toFirstUpper»",
			
			_enum: {
				«FOR element : enum.enumBody.elements SEPARATOR ","»
					VALUE«enum.enumBody.elements.indexOf(element)»: «element.quotify»
				«ENDFOR»
			}
			
		});
		
		/**
		 * Enum Factory
		 */
		return declare([], {
			
			datatype: "«enum.name.toFirstUpper»",
			
			create: function(value) {
				return new «enum.name.toFirstUpper»(value, this.typeFactory);
			}
			
		});
	'''
	
}