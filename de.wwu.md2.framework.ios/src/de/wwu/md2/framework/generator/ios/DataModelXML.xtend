package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.mD2.AttrIsOptional
import de.wwu.md2.framework.mD2.AttributeType
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

class DataModelXML
{
	def static createDataModelXML(Iterable<Entity> entities) '''
		<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
		<model name="" userDefinedModelVersionIdentifier="" type="com.apple.IDECoreDataModeler.DataModel" documentVersion="1.0" lastSavedToolsVersion="1171" systemVersion="11D50d" minimumToolsVersion="Automatic" macOSVersion="Automatic" iOSVersion="Automatic">
			<entity name="DataTransferObject" representedClassName="DataTransferObject" isAbstract="YES" syncable="YES">
				<attribute name="createdDate" optional="YES" attributeType="Date" defaultDateTimeInterval="362848762.79173" defaultValueString="now" syncable="YES"/>
				<attribute name="identifier" optional="YES" attributeType="Integer 64" minValueString="0" maxValueString="99999" defaultValueString="0" syncable="YES"/>
			</entity>
			«FOR entity : entities»
				<entity name="«entity.name.toFirstUpper»Entity" representedClassName="«entity.name.toFirstUpper»Entity" parentEntity="DataTransferObject" syncable="YES">
					«FOR attribute : entity.attributes»
						«IF !(attribute.type instanceof ReferencedType && (attribute.type as ReferencedType).entity instanceof Entity)»
							<attribute name="«attribute.name.toFirstLower»" optional="«IF isOptional(attribute.type)»YES«ELSE»NO«ENDIF»" attributeType="«getType(attribute.type)»" «getTypeSpecificParam(attribute.type)» syncable="YES"/>
						«ELSE»
							<relationship name="«attribute.name.toFirstLower»" optional="«IF isOptional(attribute.type)»YES«ELSE»NO«ENDIF»" «IF attribute.type.many»toMany="YES"«ELSE»minCount="1" maxCount="1"«ENDIF» deletionRule="Nullify" destinationEntity="«(attribute.type as ReferencedType).entity.name.toFirstUpper»Entity" syncable="YES"/>
						«ENDIF»
					«ENDFOR»
				</entity>
			«ENDFOR»
		</model>'''
	
	def static createXcCurrentVersionXML() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
		<plist version="1.0">
		<dict>
			<key>_XCCurrentVersionName</key>
			<string>DataModel.xcdatamodel</string>
		</dict>
		</plist>'''
	
	def private static isOptional(AttributeType type)
	{
		switch type
		{
			ReferencedType: type.params.exists(p | p instanceof AttrIsOptional)
			IntegerType: type.params.exists(p | p instanceof AttrIsOptional)
			FloatType: type.params.exists(p | p instanceof AttrIsOptional)
			StringType: type.params.exists(p | p instanceof AttrIsOptional)
			BooleanType: type.params.exists(p | p instanceof AttrIsOptional)
			DateType: type.params.exists(p | p instanceof AttrIsOptional)
			TimeType: type.params.exists(p | p instanceof AttrIsOptional)
			DateTimeType: type.params.exists(p | p instanceof AttrIsOptional)
			EnumType: type.params.exists(p | p instanceof AttrIsOptional)
		}
	}
	
	def private static getType(AttributeType type)
	{
		switch type
		{
			ReferencedType: if(type.entity instanceof Enum) "Integer 32"
			IntegerType: "Integer 64"
			FloatType: "Double"
			StringType: "String"
			BooleanType: "Boolean"
			DateType: "Date"
			TimeType: "Date"
			DateTimeType: "Date"
			EnumType: "Integer 32"
		}
	}
	
	def private static getTypeSpecificParam(AttributeType type)
	{
		switch type
		{
			ReferencedType: if(type.entity instanceof Enum) '''defaultValueString="1" minValueString="1" maxValueString="«getEnumSize(type.entity as Enum)»"'''
			IntegerType: '''defaultValueString="0"'''
			FloatType: '''defaultValueString="0"'''
			StringType: '''defaultValueString=""'''
			BooleanType: '''defaultValueString="NO"'''
			DateType: '''defaultValueString="now"'''
			TimeType: '''defaultValueString="now"'''
			DateTimeType: '''defaultValueString="now"'''
			EnumType: null // not used (removed in M2M preprocessing)
		}
	}
	
	def private static getEnumSize(Enum _enum)
	{
		_enum.enumBody.elements.size
	}
}