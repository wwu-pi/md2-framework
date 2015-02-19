package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.ReferencedType

import static de.wwu.md2.framework.generator.android.util.MD2AndroidUtil.*
import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ModelClass {
	
//	def static dispatch createClass(ModelElement elem, String packageName) {
//		// Handler for expected root type - no op
//	}
	
	def static dispatch createClass(Entity entity, String basePackage) '''
		package «basePackage».models;
		
		import java.util.ArrayList;
		
		import org.codehaus.jackson.annotate.JsonIgnore;
		import org.codehaus.jackson.annotate.JsonIgnoreProperties;
		import org.codehaus.jackson.map.annotate.JsonDeserialize;
		import org.codehaus.jackson.map.annotate.JsonRootName;
		import org.codehaus.jackson.map.annotate.JsonSerialize;
		
		import de.wwu.md2.android.lib.controller.contentprovider.InternalIdSerializer;
		import de.wwu.md2.android.lib.model.Entity;
		
		@JsonIgnoreProperties(ignoreUnknown = true)
		@JsonRootName("«entity.name.toFirstLower»")
		public class «entity.name» implements Entity {
			
			@JsonDeserialize(contentAs=«entity.name».class)
			@JsonRootName("«entity.name.toFirstLower»")
			public static class Array extends ArrayList<«entity.name»> {
				private static final long serialVersionUID = 1L;
				public Array() {
				}
			}
			
			@JsonSerialize(using=InternalIdSerializer.class)
			@JsonDeserialize
			private int __internalId;
			«FOR attribute : entity.attributes»
				private «attributeTypeName(entity, attribute)» «attribute.name»;
			«ENDFOR»
			
			public «entity.name»() {
				applyDefaults();
			}
			
			private void applyDefaults() {
				__internalId = -1;
				«entity.attributes.filter([typeof(ReferencedType).isInstance(it.type) && (typeof(Enum).isInstance((it.type as ReferencedType).entity) || typeof(Entity).isInstance((it.type as ReferencedType).entity))]).join('\n', ['''set«it.name.toFirstUpper»(new «attributeTypeName(it)»());'''])»
			}
			
			@JsonIgnore
			public void setInternalId(int id) {
				__internalId = id;
			}
		
			@JsonIgnore
			public int getInternalId() {
				return __internalId;
			}
			
			«FOR attribute : entity.attributes»
				public «attributeTypeName(entity, attribute)» get«attribute.name.toFirstUpper»() {
					return this.«attribute.name»;
				}
				
				public void set«attribute.name.toFirstUpper»(«attributeTypeName(entity, attribute)» value) {
					this.«attribute.name» = value;
				}
				
			«ENDFOR»
		}
	'''
	
	def static dispatch createClass(Enum md2Enum, String basePackage) {
		if (md2Enum == null) throw new IllegalArgumentException("md2Enum cannot be nil")
		if (md2Enum.enumBody == null) throw new IllegalArgumentException("Enum "+md2Enum.name+"'s enumBody cannot be empty")
		
		'''
		package «basePackage».models;
		
		import de.wwu.md2.android.lib.model.MD2Enum;
		import «basePackage».R;
		
		public class «getName(md2Enum)» extends MD2Enum {
			
			public «getName(md2Enum)»() {
			}
			
			public «getName(md2Enum)»(int selectedIdx) {
				super(selectedIdx);
			}
			
			@Override
			public int getResourceId() {
				return R.array.enum_«getName(md2Enum).toFirstLower»;
			}
		}'''
	}
	
}