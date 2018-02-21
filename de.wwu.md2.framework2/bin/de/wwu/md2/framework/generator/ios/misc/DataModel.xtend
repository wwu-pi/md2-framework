package de.wwu.md2.framework.generator.ios.misc

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.mD2.ReferencedType

/**
 * Generates the iOS data model configuration needed for the Core Data framework.
 */
class DataModel {
	
	/**
	 * Generate the data model content. This is an XML file with entries for all 
	 * entities, attributes and relationships to other entities.
	 * 
	 * @param entities The list of entity elements in the data model.
	 * @return The file content.
	 */
	def static generateClass(Iterable<Entity> entities)  '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<model userDefinedModelVersionIdentifier="" type="com.apple.IDECoreDataModeler.DataModel" documentVersion="1.0" lastSavedToolsVersion="7701" systemVersion="14C109" minimumToolsVersion="Xcode 4.3" macOSVersion="Automatic" iOSVersion="Automatic">
    «FOR entity : entities»
    <entity name="«Settings.PREFIX_ENTITY + entity.name»" representedClassName="NSManagedObject" syncable="YES">
        <attribute name="internalId" optional="YES" attributeType="String" syncable="YES"/>
        «FOR attribute : entity.attributes.filter[attr | !(attr.type instanceof ReferencedType) || (attr.type as ReferencedType).element instanceof Enum ] »
        <attribute name="«attribute.name»" optional="YES" attributeType="String" syncable="YES"/>
        «ENDFOR»
        «FOR attribute : entity.attributes.filter[attr | attr.type instanceof ReferencedType && !((attr.type as ReferencedType).element instanceof Enum) ] »
        <relationship name="«attribute.name»" optional="YES" maxCount="1" deletionRule="Nullify" destinationEntity="«Settings.PREFIX_ENTITY + (attribute.type as ReferencedType).element.name»" syncable="YES"/>
        «ENDFOR»
    </entity>
    «ENDFOR»
    <elements>
    	«FOR entity : entities»
    	<element name="«Settings.PREFIX_ENTITY + entity.name»" positionX="0" positionY="0" width="150" height="150"/>
    	«ENDFOR»
    </elements>
</model>'''
}