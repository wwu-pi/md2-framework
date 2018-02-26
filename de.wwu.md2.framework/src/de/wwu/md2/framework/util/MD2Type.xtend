package de.wwu.md2.framework.util

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import java.util.Objects
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.SimpleDataType

class MD2Type {
	
	public static final MD2Type INT = new MD2Type(SimpleDataType.INTEGER)
	public static final MD2Type FLOAT = new MD2Type(SimpleDataType.FLOAT)
	public static final MD2Type BOOL = new MD2Type(SimpleDataType.BOOLEAN)
	public static final MD2Type STRING = new MD2Type(SimpleDataType.STRING)
	public static final MD2Type DATE = new MD2Type(SimpleDataType.DATE)
	public static final MD2Type DATETIME = new MD2Type(SimpleDataType.DATE_TIME)
	public static final MD2Type TIME = new MD2Type(SimpleDataType.TIME)
	public static final MD2Type FILE = new MD2Type(SimpleDataType.STRING)
	public static final MD2Type SENSOR = new MD2Type(SimpleDataType.SENSOR)
	public static final MD2Type LOCATION = new MD2Type(SimpleDataType.STRING)
	
	protected SimpleDataType type = null
	protected String customName = null
	protected boolean isArray = false
	protected boolean isEnum = false
	protected boolean isEntity = false
	
	new(SimpleDataType t){
		type = t
	}
	
	new(ModelElement m){
		customName = m.name
		switch(m){
			Entity: isEntity = true
			Enum: isEnum = true
		}
	}
	
	def toEntity(){
		isEnum = false
		isEntity = true
		return this
	}
	
	def toEnum(){
		isEnum = true
		isEntity = false
		return this
	}
	
	def toArray(){
		isArray = true
		return this
	}
	
	def toSingleValued(){
		isArray = false
		return this
	}
	
	def isNumeric(){
		return !isArray && (type === SimpleDataType.INTEGER || type === SimpleDataType.FLOAT)
	}
	
	def isTemporal(){
		return !isArray && (type === SimpleDataType.DATE || type === SimpleDataType.TIME || type === SimpleDataType.DATE_TIME)
	}
	
	def isCollection() {
		return isArray
	}
	
	override hashCode() {
		Objects.hash(this.type, this.customName, this.isArray, this.isEnum, this.isEntity)
	}
	
	override def equals(Object obj){
		if(!(obj instanceof MD2Type)) return false
		
		return this.type === (obj as MD2Type).type && this.customName == (obj as MD2Type).customName
			&& this.isArray === (obj as MD2Type).isArray && this.isEntity === (obj as MD2Type).isEntity
			&& this.isEnum === (obj as MD2Type).isEnum
	}
	
	override def String toString(){
		val name = customName ?: type.toString
		
		if(isArray) {
			return 'array<' + name + '>'
		}
		return name;
	}
	
	def getJavaType(){
		switch (type) {
			case BOOL: return 'boolean'
			case INT: return 'int'
			case FLOAT: return 'double'
			case STRING: return 'String'
			case DATE: return 'Date'
			case DATETIME: return 'Date'
			case TIME: return 'Date'
			case FILE: return 'File'
			case SENSOR: return 'double'
			case LOCATION: return 'String' // TODO?
		}
	}
}