package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.mD2.AttrIsOptional
import de.wwu.md2.framework.mD2.AttributeType
import de.wwu.md2.framework.mD2.BooleanType
import de.wwu.md2.framework.mD2.DateTimeType
import de.wwu.md2.framework.mD2.DateType
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.FloatType
import de.wwu.md2.framework.mD2.IntegerType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.StringType
import de.wwu.md2.framework.mD2.TimeType

import static extension de.wwu.md2.framework.util.IterableExtensions.*

class EnumAndEntityClass {
	
	def static dispatch createModel(String basePackageName, Entity entity) '''
		package «basePackageName».entities.models;
		
		import java.io.Serializable;
		«IF entity.attributes.exists(a | isDateOrTimeType(a.type))»import java.util.Date;«ENDIF»
		«IF entity.attributes.exists(a | a.type.many)»import java.util.List;«ENDIF»
		
		«IF entity.attributes.exists(a | a.type instanceof ReferencedType && (a.type as ReferencedType).element instanceof Entity)»
			import javax.persistence.CascadeType;
		«ENDIF»
		import javax.persistence.Column;
		«IF entity.attributes.exists(a | a.type.many && !(a.type instanceof ReferencedType && (a.type as ReferencedType).element instanceof Entity))»
			import javax.persistence.ElementCollection;
		«ENDIF»
		import javax.persistence.Entity;
		import javax.persistence.GeneratedValue;
		import javax.persistence.GenerationType;
		import javax.persistence.Id;
		«IF entity.attributes.exists(a | a.type.many && a.type instanceof ReferencedType && (a.type as ReferencedType).element instanceof Entity)»
			import javax.persistence.ManyToMany;
		«ENDIF»
		«IF entity.attributes.exists(a | !a.type.many && a.type instanceof ReferencedType && (a.type as ReferencedType).element instanceof Entity)»
			import javax.persistence.ManyToOne;
		«ENDIF»
		«IF entity.attributes.exists(a | isDateOrTimeType(a.type))»
			import javax.persistence.Temporal;
			import javax.persistence.TemporalType;
		«ENDIF»
		import javax.validation.constraints.NotNull;
		import javax.xml.bind.annotation.XmlAccessType;
		import javax.xml.bind.annotation.XmlAccessorType;
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@Entity
		@XmlRootElement
		@XmlAccessorType(XmlAccessType.NONE)
		public class «entity.name.toFirstUpper» implements Serializable {
			
			private static final long serialVersionUID = 1L;
			
			@Id
			@GeneratedValue(strategy=GenerationType.AUTO)
			@NotNull
			@Column(name="INTERNAL_ID__")
			@XmlElement
			protected int __internalId;
			
			«FOR attribute : entity.attributes»
				«getAnnotations(attribute.type)»
				@XmlElement(nillable=true)
				protected «getDataType(attribute.type)» «attribute.name.toFirstLower»;
				
			«ENDFOR»
			
			///////////////////////////////////////
			/// Getters and setters
			///////////////////////////////////////
			
			public int getInternal__id() {
				return __internalId;
			}
			
			«FOR attribute : entity.attributes»
				public «getDataType(attribute.type)» get«attribute.name.toFirstUpper»() {
					return «attribute.name.toFirstLower»;
				}
				
				public void set«attribute.name.toFirstUpper»(«getDataType(attribute.type)» «attribute.name.toFirstLower») {
					this.«attribute.name.toFirstLower» = «attribute.name.toFirstLower»;
				}
				
			«ENDFOR»
		}
	'''
	
	def static dispatch createModel(String basePackageName, Enum _enum) '''
		package «basePackageName».entities.models;
		
		import javax.xml.bind.annotation.XmlEnumValue;
		
		public enum «_enum.name.toFirstUpper» {
			
			«_enum.enumBody.elements.joinWithIdx("", "," + System::getProperty("line.separator"), ";", [s, i | '''@XmlEnumValue("«i»") VALUE«i»("«s»")'''])»
			
			private String value;
			
			«_enum.name.toFirstUpper»(String value) {
				this.value = value;
			}
			
			public String getValue() {
				return this.value;
			}
			
		}
	'''
	
	def static createWorkflowState(String basePackageName) '''
		package «basePackageName».entities;
		
		import java.io.Serializable;
		
		import javax.persistence.Column;
		import javax.persistence.Entity;
		import javax.persistence.GeneratedValue;
		import javax.persistence.GenerationType;
		import javax.persistence.Id;
		import javax.validation.constraints.NotNull;
		import javax.xml.bind.annotation.XmlAccessType;
		import javax.xml.bind.annotation.XmlAccessorType;
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		
		/**
		 * 
		 * Each workflowState corresponds to a workflowInstance and keeps track of its state,
		 * which is represented by the current workflowElement and the last event fired.
		 *
		 */
		@Entity
		@XmlRootElement
		@XmlAccessorType(XmlAccessType.NONE)
		public class WorkflowState implements Serializable {
			
			private static final long serialVersionUID = 1L;
			
			@Id
			@GeneratedValue(strategy=GenerationType.AUTO)
			@NotNull
			@Column(name="INTERNAL_ID__")
			@XmlElement
			protected int __internalId;
			
			@Column(unique=true)
			@NotNull
			@XmlElement(nillable=true)
			protected String instanceId;
			
			@NotNull
			@XmlElement(nillable=true)
			protected String currentWorkflowElement;
			
			@NotNull
			@XmlElement(nillable=true)
			protected String lastEventFired; 
			
			@XmlElement(nillable=true)
			protected String contentProviderIds; 
			
			///////////////////////////////////////
			/// constructor
			///////////////////////////////////////
			
			public WorkflowState(){
				
			}
			
			public WorkflowState (String lastEventFired, String instanceId, String wfe, String contentProviderIds) {
				this.instanceId = instanceId;
				this.lastEventFired = lastEventFired;
				this.currentWorkflowElement = wfe;
				this.contentProviderIds = contentProviderIds;
			}
			
			///////////////////////////////////////
			/// Getters and setters
			///////////////////////////////////////
		
			public int getInternal__id() {
				return __internalId;
			}
			
			public String get_instanceId() {
				return instanceId;
			}
		
			public String getCurrentWorkflowElement() {
				return currentWorkflowElement;
			}
			
			public void setCurrentWorkflowElement(String currentWorkflowElement) {
				this.currentWorkflowElement = currentWorkflowElement;
			}
			
			public String getLastEventFired() {
				return lastEventFired;
			}
			
			public void setLastEventFired(String lastEventFired) {
				this.lastEventFired = lastEventFired;
			}
			
			public String getContentProviderIds() {
				return contentProviderIds;
			}
			
			public void setContentProviderIds(String contentProviderIds) {
				this.contentProviderIds = contentProviderIds;
			}
		}
	'''
	
	def private static getDataType(AttributeType type) {
		val dataType = switch type {
			ReferencedType: type.element.name.toFirstUpper
			IntegerType: "int"
			FloatType: "double"
			StringType: "String"
			BooleanType: "boolean"
			DateType: "Date"
			TimeType: "Date"
			DateTimeType: "Date"
		}
		
		// return
		if(type.many) {
			"List<" + dataType + ">"
		} else {
			dataType
		}
	}
	
	def private static getAnnotations(AttributeType type) {
		
		val StringBuilder result = new StringBuilder()
		val NEW_LINE = System::getProperty("line.separator")
		
		val isOptional = switch type {
			ReferencedType: type.params
			IntegerType: type.params
			FloatType: type.params
			StringType: type.params
			BooleanType: type.params
			DateType: type.params
			TimeType: type.params
			DateTimeType: type.params
		}.exists(p | p instanceof AttrIsOptional)
		
		val isEntity = type instanceof ReferencedType && (type as ReferencedType).element instanceof Entity
		
		if(!isOptional) {
			result.append("@NotNull").append(NEW_LINE)
		}
		
		if(type instanceof DateType) {
			result.append("@Temporal(TemporalType.DATE)").append(NEW_LINE)
		} else if(type instanceof TimeType) {
			result.append("@Temporal(TemporalType.TIME)").append(NEW_LINE)
		} else if(type instanceof DateTimeType) {
			result.append("@Temporal(TemporalType.TIMESTAMP)").append(NEW_LINE)
		}
		
		if(type.many && !isEntity) {
			result.append("@ElementCollection(fetch=FetchType.EAGER)").append(NEW_LINE)
		} else if(type.many && isEntity) {
			result.append("@ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})").append(NEW_LINE)
		} else if(!type.many && isEntity) {
			result.append("@ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}")
			if(isOptional) {
				result.append(", optional=true")
			}
			result.append(")").append(NEW_LINE)
		}
		
		result.toString
	}
	
	def private static isDateOrTimeType(AttributeType type) {
		type instanceof DateType || type instanceof TimeType || type instanceof DateTimeType
	}
}
