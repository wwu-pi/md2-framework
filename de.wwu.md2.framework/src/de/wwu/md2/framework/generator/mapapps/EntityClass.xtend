package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.mD2.AttrBooleanDefault
import de.wwu.md2.framework.mD2.AttrDateDefault
import de.wwu.md2.framework.mD2.AttrDateTimeDefault
import de.wwu.md2.framework.mD2.AttrEnumDefault
import de.wwu.md2.framework.mD2.AttrFloatDefault
import de.wwu.md2.framework.mD2.AttrIntDefault
import de.wwu.md2.framework.mD2.AttrStringDefault
import de.wwu.md2.framework.mD2.AttrTimeDefault
import de.wwu.md2.framework.mD2.Attribute
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType
import java.util.Map

import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class EntityClass {
	
	def static String generateEntity(Entity entity) '''
		«val imports = newLinkedHashMap("declare" -> "dojo/_base/declare", "_Entity" -> "md2_runtime/entities/_Entity")»
		«val body = generateEntityBody(entity, imports)»
		define([
			«FOR key : imports.keySet SEPARATOR ","»
				"«imports.get(key)»"
			«ENDFOR»
		],
		function(«FOR key : imports.keySet SEPARATOR ", "»«key»«ENDFOR») {
			
			«body»
		});
	'''
	
	def private static generateEntityBody(Entity entity, Map<String, String> imports) '''
		var «entity.name» = declare([_Entity], {
			
			_datatype: "«entity.name»",
			
			attributeTypes: {
				«FOR attribute : entity.attributes SEPARATOR ","»
					«attribute.name»: "«attribute.generateAttributeDataType»"
				«ENDFOR»
			},
			
			_initialize: function() {
				this._attributes = {
					«FOR attribute : entity.attributes SEPARATOR ","»
						«attribute.name»: «attribute.generateAttributeDefaultValue(imports)»
					«ENDFOR»
				};
			}
			
		});
		
		/**
		 * Entity Factory
		 */
		return declare([], {
			
			datatype: "«entity.name»",
			
			create: function() {
				return new «entity.name»(this.typeFactory);
			}
			
		});
	'''
	
	/**
	 * Get a string representation of the default value for each attribute
	 */
	def private static generateAttributeDefaultValue(Attribute attribute, Map<String, String> imports) {
		val type = attribute.type
		switch (type) {
			ReferencedType: {
				val element = type.element
				switch element {
					Entity: '''null'''
					Enum: {
						val defaultValue = type.params.filter(AttrEnumDefault).head
						'''this._typeFactory.create("«element.name.toFirstUpper»", "«IF defaultValue != null»VALUE«element.enumBody.elements.indexOf(defaultValue.value)»«ELSE»VALUE0«ENDIF»")'''
					}
				}
			}
			IntegerType: {
				val defaultValue = type.params.filter(AttrIntDefault).head
				'''this._typeFactory.create("integer", «IF defaultValue != null»«defaultValue.value»«ELSE»null«ENDIF»)'''
			}
			FloatType: {
				val defaultValue = type.params.filter(AttrFloatDefault).head
				'''this._typeFactory.create("float", «IF defaultValue != null»«defaultValue.value»«ELSE»null«ENDIF»)'''
			}
			StringType: {
				val defaultValue = type.params.filter(AttrStringDefault).head
				'''this._typeFactory.create("string", «defaultValue?.value.quotify ?: '''null'''»)'''
			}
			BooleanType: {
				val defaultValue = type.params.filter(AttrBooleanDefault).head
				'''this._typeFactory.create("boolean", «defaultValue?.value ?: '''false'''»)'''
			}
			DateType: {
				val defaultValue = type.params.filter(AttrDateDefault).head
				if (defaultValue != null) {
					imports.put("stamp", "dojo/date/stamp")
				}
				'''this._typeFactory.create("date", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISODate»")«ELSE»null«ENDIF»)'''
			}
			TimeType: {
				val defaultValue = type.params.filter(AttrTimeDefault).head
				if (defaultValue != null) {
					imports.put("stamp", "dojo/date/stamp")
				}
				'''this._typeFactory.create("time", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISOTime»")«ELSE»null«ENDIF»)'''
			}
			DateTimeType: {
				val defaultValue = type.params.filter(AttrDateTimeDefault).head
				if (defaultValue != null) {
					imports.put("stamp", "dojo/date/stamp")
				}
				'''this._typeFactory.create("datetime", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISODateTime»")«ELSE»null«ENDIF»)'''
			}
			EnumType: {
				val defaultValue = type.params.filter(AttrEnumDefault).head
				'''this._typeFactory.create("string", «defaultValue?.value.quotify ?: '''null'''»)'''
			}
		}
	}
	
	def private static generateAttributeDataType(Attribute attribute) {
		val type = attribute.type
		switch (type) {
			ReferencedType: '''«type.element.name.toFirstUpper»'''
			IntegerType: '''integer'''
			FloatType: '''float'''
			StringType: '''string'''
			BooleanType: '''boolean'''
			DateType: '''date'''
			TimeType: '''time'''
			DateTimeType: '''datetime'''
			default: throw new Error("Data type not supported!")
		}
	}
}