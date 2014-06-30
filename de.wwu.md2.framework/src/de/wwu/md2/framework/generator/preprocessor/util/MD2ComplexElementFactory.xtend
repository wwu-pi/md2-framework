package de.wwu.md2.framework.generator.preprocessor.util

import de.wwu.md2.framework.mD2.impl.MD2FactoryImpl
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.AttributeType

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*

/**
 * Helper factory class that creates complex/compound MD2 elements. E.g. creates and configures a
 * contentProvider for a given entity or creates an entity with a given list of attributes.
 * 
 * It also inherits from the actual MD2Factory implementation generated by Xtext, so that all basic
 * createXXX methods are available as well. All factory methods for compound elements are prefixed with
 * Complex, i.e. createComplexXXX.
 */
class MD2ComplexElementFactory extends MD2FactoryImpl {
	
	def MD2ComplexElementFactory() {
		super
	}
	
	/**
	 * Creates an entity with the given name and a set of attributes. Each attribute is defined by a pair
	 * with the attribute name as the key and the attribute type (Xtend syntax: "nameString"->attributeType).
	 * The attribute types are implicitly copied, so that the same instance can be reused in the attributes definition.
	 * 
	 * @param name - Name of the entity.
	 * @param attributes - Arbitrary number of pairs with the attribute name as the key and the attribute type.
	 */
	def createComplexEntity(String name, Pair<String, AttributeType>... attributes) {
		val entity = this.createEntity
		entity.setName(name)
		
		for (attr : attributes) {
			val attribute = this.createAttribute
			attribute.setName(attr.key)
			attribute.setType(attr.value.copy)
			entity.attributes.add(attribute)
		}
		
		return entity
	}
	
	/**
	 * Creates a content provider for a given entity.
	 * 
	 * @param entity - The entity for which the content provider is created.
	 * @param name - Name of the content provider. Suggestion: __entityNameProvider.
	 * @param isLocal - Defines whether it is a local (true) or a remote (false) content provider.
	 * @param isReadonly - Specifies whether the content provider is read-only, i.e. data cannot be set via mappings or setters in the controller.
	 */
	def createComplexContentProvider(Entity entity, String name, boolean isLocal, boolean isReadonly) {
		val referencedModelType = this.createReferencedModelType
		referencedModelType.setEntity(entity)
		
		val contentProvider = this.createContentProvider
		contentProvider.setName(name)
		contentProvider.setType(referencedModelType)
		contentProvider.setLocal(isLocal)
		contentProvider.setReadonly(isReadonly)
		
		return contentProvider
	}
	
	/**
	 * 
	 */
	def createComplexRecursiveList(String name, Entity entity) {
		
	}
}