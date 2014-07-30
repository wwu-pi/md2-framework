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
import de.wwu.md2.framework.mD2.EnumType
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType

import static extension de.wwu.md2.framework.util.DateISOFormatter.*
import static extension de.wwu.md2.framework.util.StringExtensions.*

class EntityClass {
	
	def static String generateEntity(Entity entity) '''
		«val hasDateValue = !entity.attributes.filter[ a |
			a.type instanceof DateType || a.type instanceof TimeType || a.type instanceof DateTimeType
		].empty»
		define([
			"dojo/_base/declare",
			«IF hasDateValue»"dojo/date/stamp",«ENDIF»
			"md2_runtime/entities/_Entity"
		],
		function(declare, «IF hasDateValue»stamp, «ENDIF»_Entity) {
			
			var «entity.name» = declare([_Entity], {
				
				_datatype: "«entity.name»",
				
				attributeTypes: {
					«FOR attribute : entity.attributes SEPARATOR ","»
						«attribute.name»: "«attribute.attributeDataType»"
					«ENDFOR»
				},
				
				_initialize: function() {
					this._attributes = {
						«FOR attribute : entity.attributes SEPARATOR ","»
							«attribute.name»: «attribute.attributeDefaultValue»
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
		});
	'''
	
	/**
	 * Get a string representation of the default value for each attribute
	 */
	def private static getAttributeDefaultValue(Attribute attribute) {
		val type = attribute.type
		switch (type) {
			ReferencedType: {
				'''null'''
			}
			IntegerType: {
				val defaultValue = type.params.filter(typeof(AttrIntDefault)).head
				'''this._typeFactory.create("integer", «IF defaultValue != null»«defaultValue.value»«ELSE»null«ENDIF»)'''
			}
			FloatType: {
				val defaultValue = type.params.filter(typeof(AttrFloatDefault)).head
				'''this._typeFactory.create("float", «IF defaultValue != null»«defaultValue.value»«ELSE»null«ENDIF»)'''
			}
			StringType: {
				val defaultValue = type.params.filter(typeof(AttrStringDefault)).head
				'''this._typeFactory.create("string", «defaultValue?.value.quotify ?: '''null'''»)'''
			}
			BooleanType: {
				val defaultValue = type.params.filter(typeof(AttrBooleanDefault)).head
				'''this._typeFactory.create("boolean", «defaultValue?.value ?: '''false'''»)'''
			}
			DateType: {
				val defaultValue = type.params.filter(typeof(AttrDateDefault)).head
				'''this._typeFactory.create("date", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISODate»")«ELSE»null«ENDIF»)'''
			}
			TimeType: {
				val defaultValue = type.params.filter(typeof(AttrTimeDefault)).head
				'''this._typeFactory.create("time", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISOTime»")«ELSE»null«ENDIF»)'''
			}
			DateTimeType: {
				val defaultValue = type.params.filter(typeof(AttrDateTimeDefault)).head
				'''this._typeFactory.create("datetime", «IF defaultValue != null»stamp.fromISOString("«defaultValue?.value.toISODateTime»")«ELSE»null«ENDIF»)'''
			}
			EnumType: {
				val defaultValue = type.params.filter(typeof(AttrEnumDefault)).head
				'''this._typeFactory.create("string", «defaultValue?.value.quotify ?: '''null'''»)'''
			}
		}
	}
	
	def private static getAttributeDataType(Attribute attribute) {
		val type = attribute.type
		switch (type) {
			ReferencedType: '''«type.entity.name»'''
			IntegerType: '''integer'''
			FloatType: '''float'''
			StringType: '''string'''
			BooleanType: '''boolean'''
			DateType: '''date'''
			TimeType: '''time'''
			DateTimeType: '''datetime'''
			EnumType: '''string'''
		}
	}
}